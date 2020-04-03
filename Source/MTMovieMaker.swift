//
//  MTMovieMaker.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/25.
//

import Foundation
import AVFoundation
import MetalPetal

public enum MTMovieMakerError: Error {
    case imagesMustMoreThanTwo
    case imagesAndEffectsDoesNotMatch
}

public typealias MTMovieMakerProgressHandler = (Float) -> Void

public typealias MTMovieMakerCompletion = (Result<URL, Error>) -> Void

// Create video from images with transitions
public class MTMovieMaker: NSObject {
    
    private var writer: AVAssetWriter?
    
    private let outputURL: URL
    
    private let writingQueue: DispatchQueue
    
    private var exportSession: AVAssetExportSession?
    
    public init(outputURL: URL) {
        self.outputURL = outputURL
        self.writingQueue = DispatchQueue(label: "me.shuifeng.MTTransitions.MovieWriter.writingQueue")
        super.init()
    }
    
    /// Create video from images with single transition effect.
    /// - Parameters:
    ///   - images: The input images. Should be same width and height.
    ///   - effect: The transition applied to switch images
    ///   - frameDuration: The duration each image display.
    ///   - transitionDuration: The duration of transition.
    ///   - audioURL: The local url of audio to be mixed to the video.
    ///   - completion: completion callback.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [MTIImage],
                            effect: MTTransition.Effect,
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
                            audioURL: URL? = nil,
                            completion: MTMovieMakerCompletion? = nil) throws {
        let effects = Array(repeating: effect, count: images.count - 1)
        try createVideo(with: images,
                        effects: effects,
                        frameDuration: frameDuration,
                        transitionDuration: transitionDuration,
                        audioURL: audioURL,
                        completion: completion)
    }
    
    /// Create video from images.
    /// - Parameters:
    ///   - images: The input images. Should be same width and height.
    ///   - effects: The transition applied to switch images. The number of effects must equals to images.count - 1.
    ///   - frameDuration: The duration each image display.
    ///   - transitionDuration: The duration of transition.
    ///   - audioURL: The local url of audio to be mixed to the video.
    ///   - completion: completion callback.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [UIImage],
                            effects: [MTTransition.Effect],
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
                            audioURL: URL? = nil,
                            completion: @escaping MTMovieMakerCompletion) throws {
        
        
        let inputImages = images.map {
            return MTIImage(cgImage: $0.cgImage!, options: [.SRGB: false]).oriented(.downMirrored)
        }
        try createVideo(with: inputImages,
                        effects: effects,
                        frameDuration: frameDuration,
                        transitionDuration: transitionDuration,
                        audioURL: audioURL,
                        completion: completion)
    }
    
    /// Create video from images.
    /// - Parameters:
    ///   - images: The input images. Should be same width and height.
    ///   - effects: The transition applied to switch images. The number of effects must equals to images.count - 1.
    ///   - frameDuration: The duration each image display.
    ///   - transitionDuration: The duration of transition.
    ///   - audioURL: The local url of audio to be mixed to the video.
    ///   - completion: completion callback.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [MTIImage],
                            effects: [MTTransition.Effect],
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
                            audioURL: URL? = nil,
                            completion: MTMovieMakerCompletion? = nil) throws {
        
        guard images.count >= 2 else {
            throw MTMovieMakerError.imagesMustMoreThanTwo
        }
        guard effects.count == images.count - 1 else {
            throw MTMovieMakerError.imagesAndEffectsDoesNotMatch
        }
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }
        
        writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        let outputSize = images.first!.size
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: outputSize.width,
            AVVideoHeightKey: outputSize.height
        ]
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        let attributes = sourceBufferAttributes(outputSize: outputSize)
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput,
                                                                      sourcePixelBufferAttributes: attributes)
        writer?.add(writerInput)
        
        guard let success = writer?.startWriting(), success == true else {
            fatalError("Can not start writing")
        }
        
        guard let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool else {
            fatalError("AVAssetWriterInputPixelBufferAdaptor pixelBufferPool empty")
        }
        
        self.writer?.startSession(atSourceTime: .zero)
        writerInput.requestMediaDataWhenReady(on: self.writingQueue) {
            var index = 0
            while index < (images.count - 1) {
                var presentTime = CMTimeMake(value: Int64(frameDuration * Double(index) * 1000), timescale: 1000)
                let transition = effects[index].transition
                transition.inputImage = images[index]
                transition.destImage = images[index + 1]
                transition.duration = transitionDuration
                
                let frameBeginTime = presentTime
                let frameCount = 29
                for counter in 0 ... frameCount {
                    autoreleasepool {
                        while !writerInput.isReadyForMoreMediaData {
                            Thread.sleep(forTimeInterval: 0.01)
                        }
                        let progress = Float(counter) / Float(frameCount)
                        transition.progress = progress
                        let frameTime = CMTimeMake(value: Int64(transitionDuration * Double(progress) * 1000), timescale: 1000)
                        presentTime = CMTimeAdd(frameBeginTime, frameTime)
                        var pixelBuffer: CVPixelBuffer?
                        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBuffer)
                        if let buffer = pixelBuffer, let frame = transition.outputImage {
                            try? MTTransition.context?.render(frame, to: buffer)
                            pixelBufferAdaptor.append(buffer, withPresentationTime: presentTime)
                        }
                    }
                }
                index += 1
            }
            writerInput.markAsFinished()
            self.writer?.finishWriting {
                if let audioURL = audioURL, self.writer?.error == nil {
                    do {
                        let audioAsset = AVAsset(url: audioURL)
                        let videoAsset = AVAsset(url: self.outputURL)
                        try self.mixAudio(audioAsset, video: videoAsset, completion: completion)
                    } catch {
                        completion?(.failure(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        if let error = self.writer?.error {
                            completion?(.failure(error))
                        } else {
                            completion?(.success(self.outputURL))
                        }
                    }
                }
            }
        }
    }
    
    private func sourceBufferAttributes(outputSize: CGSize) -> [String: Any] {
        let attributes: [String: Any] = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            (kCVPixelBufferWidthKey as String): outputSize.width,
            (kCVPixelBufferHeightKey as String): outputSize.height
        ]
        return attributes
    }
    
    private func mixAudio(_ audio: AVAsset, video: AVAsset, completion: MTMovieMakerCompletion? = nil) throws {
        guard let videoTrack = video.tracks(withMediaType: .video).first else {
            fatalError("Can not found videoTrack in Video File")
        }
        guard let audioTrack = audio.tracks(withMediaType: .audio).first else {
            fatalError("Can not found audioTrack in Audio File")
        }
        
        let composition = AVMutableComposition()
        guard let videoComposition = composition.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID(1)),
            let audioComposition = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID(2)) else {
            return
        }
        
        let videoTimeRange = CMTimeRange(start: .zero, duration: video.duration)
        try videoComposition.insertTimeRange(videoTimeRange, of: videoTrack, at: .zero)
        
        if video.duration > audio.duration {
            let repeatCount = Int(video.duration.seconds / audio.duration.seconds)
            let remain = video.duration.seconds.truncatingRemainder(dividingBy: audio.duration.seconds)
            let audioTimeRange = CMTimeRange(start: .zero, duration: audio.duration)
            for i in 0 ..< repeatCount {
                let start = CMTime(seconds: Double(i) * audio.duration.seconds, preferredTimescale: audio.duration.timescale)
                try audioComposition.insertTimeRange(audioTimeRange, of: audioTrack, at: start)
            }
            if remain > 0 {
                let startSeconds = Double(repeatCount) * audio.duration.seconds
                let start = CMTime(seconds: startSeconds, preferredTimescale: audio.duration.timescale)
                let remainDuration = CMTime(seconds: remain, preferredTimescale: audio.duration.timescale)
                let remainTimeRange = CMTimeRange(start: .zero, duration: remainDuration)
                try audioComposition.insertTimeRange(remainTimeRange, of: audioTrack, at: start)
            }
        } else {
            let audioTimeRange = CMTimeRangeMake(start: .zero, duration: video.duration)
            try audioComposition.insertTimeRange(audioTimeRange, of: audioTrack, at: .zero)
        }
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("temp.mp4"))
        try? FileManager.default.removeItem(at: tempURL)
        exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = tempURL
        exportSession?.timeRange = videoTimeRange
        exportSession?.exportAsynchronously { [weak self] in
            guard let self = self, let exporter = self.exportSession else { return }
            DispatchQueue.main.async {
                if let error = exporter.error {
                    completion?(.failure(error))
                } else {
                    do {
                        if FileManager.default.fileExists(atPath: self.outputURL.path) {
                            try FileManager.default.removeItem(at: self.outputURL)
                        }
                        try FileManager.default.moveItem(at: tempURL, to: self.outputURL)
                        completion?(.success(self.outputURL))
                    } catch {
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
}
