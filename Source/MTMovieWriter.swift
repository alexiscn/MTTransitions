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

// Create video from images with transitions
// TODO
public class MTMovieWriter: NSObject {

    /// Video Settings
    public var videoTrackSettings: [String: Any]?
    
    /// Audio Settings
    public var audioTrackSettings: [String: Any]?
    
    private var writer: AVAssetWriter?
    
    private let outputURL: URL
    
    private let queue: DispatchQueue
    
    private let writingQueue: DispatchQueue
    
    private var images: [UIImage] = []
    
    private let context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    public init(outputURL: URL) {
        self.outputURL = outputURL
        self.queue = DispatchQueue(label: "me.shuifeng.MTTransitions.MovieWriter")
        self.writingQueue = DispatchQueue(label: "me.shuifeng.MTTransitions.MovieWriter.writingQueue")
        super.init()
    }
    
    public func makeVideo(with images: [UIImage],
                          effect: MTTransition.Effect,
                          frameDuration: TimeInterval,
                          transitionDuration: TimeInterval) throws {
        
        guard images.count >= 2 else {
            throw MTMovieWriterError.imagesMustMoreThanTwo
        }
        self.images = images
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
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32ARGB,
            (kCVPixelBufferWidthKey as String): outputSize.width,
            (kCVPixelBufferHeightKey as String): outputSize.height,
            (kCVPixelBufferCGImageCompatibilityKey as String): NSNumber(value: true),
            (kCVPixelBufferCGBitmapContextCompatibilityKey as String): NSNumber(value: true)
        ]
        
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: sourceBufferAttributes)
        writer?.add(writerInput)
        
        guard let success = writer?.startWriting(), success == true else {
            fatalError("Can not start writing")
        }
        writer?.startSession(atSourceTime: .zero)
        writerInput.requestMediaDataWhenReady(on: writingQueue) {
            var index = 0
            let presentTime = CMTimeMake(value: 0, timescale: 600)
            while true {
                if index >= images.count {
                    break
                }
                while !writerInput.isReadyForMoreMediaData {
                    Thread.sleep(forTimeInterval: 0.1)
                }
                let fromImage = images[index]
                let toImage: UIImage? = (index != images.count - 1) ? images[index + 1] : nil

                if let buffer = self.createPixelBuffer(from: fromImage) {
                    pixelBufferAdaptor.append(buffer, withPresentationTime: presentTime)
                }
                // TODO
                let seamphore = DispatchSemaphore(value: 0)
                if let fromCGImage = fromImage.cgImage, let toCGImage = toImage?.cgImage {
                    let from = MTIImage(cgImage: fromCGImage, options: nil).oriented(.downMirrored)
                    let to = MTIImage(cgImage: toCGImage, options: nil).oriented(.downMirrored)
                    effect.transition.duration = transitionDuration
                    effect.transition.transition(from: from, to: to, updater: { image in
                        print(effect.transition.progress)
                        if let buffer = self.createPixelBuffer(size: outputSize) {
                            try? self.context?.render(image, to: buffer)
                            pixelBufferAdaptor.append(buffer, withPresentationTime: presentTime)
                        }
                    }) { _ in
                        seamphore.signal()
                    }
                    seamphore.wait()
                }
                index += 1
            }
            writerInput.markAsFinished()
            self.writer?.finishWriting {
                if let error = self.writer?.error {
                    print(error)
                } else {
                    print("write success")
                }
            }
        }
    }
    
    private func createPixelBuffer(size: CGSize) -> CVPixelBuffer? {
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: NSNumber(value: true),
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: NSNumber(value: true)
        ]
        
        var buffer: CVPixelBuffer?
        CVPixelBufferCreate(
            kCFAllocatorDefault, Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32ARGB,
            options as CFDictionary?,
            &buffer
        )
        return buffer
    }
    
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
    }
}
