//
//  MTMovieWriter.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/25.
//

import Foundation
import AVFoundation
import MetalPetal

public enum MTMovieWriterError: Error {
    case imagesMustMoreThanTwo
    case imagesAndEffectsDoesNotMatch
}

public typealias MTMovieWriterCompletion = (Result<URL, Error>) -> Void

// Create video from images with transitions
public class MTMovieWriter: NSObject {

    /// Video Settings
    public var videoTrackSettings: [String: Any]?
    
    /// Audio Settings
    public var audioTrackSettings: [String: Any]?
    
    private var writer: AVAssetWriter?
    
    private let outputURL: URL
    
    private let writingQueue: DispatchQueue
    
    private let context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    public init(outputURL: URL) {
        self.outputURL = outputURL
        self.writingQueue = DispatchQueue(label: "me.shuifeng.MTTransitions.MovieWriter.writingQueue")
        super.init()
    }
    
    /// Create video from images.
    /// - Parameters:
    ///   - images: The input images. Should be same width and height.
    ///   - effects: The transition applied to switch images. The number of effects must equals to images.count - 1.
    ///   - frameDuration: The duration each image display.
    ///   - transitionDuration: The duration of transition.
    /// - Throws: Throws an exception.
    public func createVideo(with images: [MTIImage],
                            effects: [MTTransition.Effect],
                            frameDuration: TimeInterval = 1,
                            transitionDuration: TimeInterval = 0.8,
                            completion: @escaping MTMovieWriterCompletion) throws {
        guard images.count >= 2 else {
            throw MTMovieWriterError.imagesMustMoreThanTwo
        }
        guard effects.count == images.count - 1 else {
            throw MTMovieWriterError.imagesAndEffectsDoesNotMatch
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

        let sourceBufferAttributes: [String: Any] = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            (kCVPixelBufferWidthKey as String): outputSize.width,
            (kCVPixelBufferHeightKey as String): outputSize.height
        ]
        
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput,
                                                                      sourcePixelBufferAttributes: sourceBufferAttributes)
        writer?.add(writerInput)
        
        guard let success = writer?.startWriting(), success == true else {
            fatalError("Can not start writing")
        }
        writer?.startSession(atSourceTime: .zero)
        writerInput.requestMediaDataWhenReady(on: writingQueue) {
            var index = 0
            while index < images.count {
                var presentTime = CMTimeMake(value: Int64(frameDuration * Double(index) * 1000), timescale: 1000)
                let fromImage = images[index]
                let toImage = (index != images.count - 1) ? images[index + 1] : nil
                
                // Do the transition, simluate progress from 0.0 - 1.0
                if let toImage = toImage {
                    let transition = effects[index].transition
                    transition.inputImage = fromImage
                    transition.destImage = toImage
                    transition.duration = transitionDuration
                    let frameBeginTime = presentTime
                    
                    for counter in 0 ... 30 {
                        while !writerInput.isReadyForMoreMediaData {
                            Thread.sleep(forTimeInterval: 0.01)
                        }
                        let progress = Float(counter) / 30
                        transition.progress = progress
                        let frameTime = CMTimeMake(value: Int64(transitionDuration * Double(progress) * 1000), timescale: 1000)
                        presentTime = CMTimeAdd(frameBeginTime, frameTime)
                        if let buffer = self.createPixelBuffer(size: outputSize), let frame = transition.outputImage {
                            try? self.context?.render(frame, to: buffer)
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
                        completion(.failure(error))
                    } else {
                        completion(.success(self.outputURL))
                    }
                }
            }
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
