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
    ///   - completion: completion callback.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [MTIImage],
                            effect: MTTransition.Effect,
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
                            completion: MTMovieMakerCompletion? = nil) throws {
        let effects = Array(repeating: effect, count: images.count - 1)
        try createVideo(with: images,
                        effects: effects,
                        frameDuration: frameDuration,
                        transitionDuration: transitionDuration,
                        completion: completion)
    }
    
    /// Create video from images.
    /// - Parameters:
    ///   - images: The input images. Should be same width and height.
    ///   - effects: The transition applied to switch images. The number of effects must equals to images.count - 1.
    ///   - frameDuration: The duration each image display.
    ///   - transitionDuration: The duration of transition.
    ///   - completion: completion callback.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [UIImage],
                            effects: [MTTransition.Effect],
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
                            completion: @escaping MTMovieMakerCompletion) throws {
        
        
        let inputImages = images.map {
            return MTIImage(cgImage: $0.cgImage!, options: [.SRGB: false]).oriented(.downMirrored)
        }
        try createVideo(with: inputImages,
                        effects: effects,
                        frameDuration: frameDuration,
                        transitionDuration: transitionDuration,
                        completion: completion)
    }
    
    /// Create video from images.
    /// - Parameters:
    ///   - images: The input images. Should be same width and height.
    ///   - effects: The transition applied to switch images. The number of effects must equals to images.count - 1.
    ///   - frameDuration: The duration each image display.
    ///   - transitionDuration: The duration of transition.
    ///   - completion: completion callback.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [MTIImage],
                            effects: [MTTransition.Effect],
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
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
                        if let buffer = self.createPixelBuffer(size: outputSize), let frame = transition.outputImage {
                            try? MTTransition.context?.render(frame, to: buffer)
                            pixelBufferAdaptor.append(buffer, withPresentationTime: presentTime)
                        }
                    }
                }
                index += 1
            }
            writerInput.markAsFinished()
            self.writer?.finishWriting {
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
    
    private func sourceBufferAttributes(outputSize: CGSize) -> [String: Any] {
        let attributes: [String: Any] = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            (kCVPixelBufferWidthKey as String): outputSize.width,
            (kCVPixelBufferHeightKey as String): outputSize.height
        ]
        return attributes
    }
    
    // TODO: Add movie maker audio support
    private func mixAudio(_ audio: AVAsset, video: AVAsset) {
        guard let audioTrack = audio.tracks(withMediaType: .audio).first else {
            return
        }
        let composition = AVMutableComposition()
        if video.duration > audio.duration {
            
        } else {
            let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            let timeRange = CMTimeRangeMake(start: .zero, duration: video.duration)
            try? track?.insertTimeRange(timeRange, of: audioTrack, at: .zero)
        }
    }
    
    private func createPixelBuffer(size: CGSize) -> CVPixelBuffer? {
        let options: [String: Any] = [
            (kCVPixelBufferIOSurfacePropertiesKey as String): [:],
            (kCVPixelBufferCGImageCompatibilityKey as String): NSNumber(value: true)
        ]
        var buffer: CVPixelBuffer?
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32BGRA,
            options as CFDictionary,
            &buffer
        )
        return buffer
    }
    
    /*
    private func createPixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        
        guard let cgImage = image.cgImage else {
            return nil
        }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        var pixelBuffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32BGRA ,
                                         nil,
                                         &pixelBuffer)
        if status != kCVReturnSuccess || pixelBuffer == nil {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                                space: rgbColorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }*/
}
