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

    public var videoTrackSettings: [String: Any] = [:]
    
    public var audioTrackSettings: [String: Any] = [:]
    
    private var assetWriter: AVAssetWriter?
    
    private let outputURL: URL
    
    public init(outputURL: URL) {
        self.outputURL = outputURL
        super.init()
    }
    
    public func makeVideo(with images: [UIImage],
                          effect: MTTransition.Effect,
                          frameDuration: TimeInterval,
                          transitionDuration: TimeInterval) throws {
        
        guard images.count >= 2 else {
            throw MTMovieWriterError.imagesMustMoreThanTwo
        }
//        
//        guard effects.count == images.count - 1 else {
//            throw MTVideoTransitionError.imagesAndEffectsDoesNotMatch
//        }
//        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("video.mp4"))
//        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
//        if fileExists {
//            do {
//                try FileManager.default.removeItem(atPath: fileURL.path)
//            } catch {
//                print("An error occured deleting the file: \(error)")
//            }
//        }
//        let outputSize = images.first!.size
//        self.writer = try AVAssetWriter(outputURL: fileURL, fileType: .mp4)
//        let videoSettings: [String: Any] = [
//            AVVideoCodecKey: AVVideoCodecH264,
//            AVVideoWidthKey: outputSize.width,
//            AVVideoHeightKey: outputSize.height
//        ]
//        
//        let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
//        let sourceBufferAttributes: [String: Any] = [
//            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32ARGB,
//            (kCVPixelBufferWidthKey as String): outputSize.width,
//            (kCVPixelBufferHeightKey as String): outputSize.height,
//            (kCVPixelBufferCGImageCompatibilityKey as String): NSNumber(value: true),
//            (kCVPixelBufferCGBitmapContextCompatibilityKey as String): NSNumber(value: true)
//        ]
//        
//        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: sourceBufferAttributes)
//        self.writer?.add(assetWriterInput)
        
        let seamphore = DispatchSemaphore(value: 0)
        for index in  0 ..< (images.count - 1) {
            let fromImage = images[index]
            let toImage = images[index + 1]
            if let fromCGImage = fromImage.cgImage, let toCGImage = toImage.cgImage {
                let from = MTIImage(cgImage: fromCGImage, options: nil).oriented(.downMirrored)
                let to = MTIImage(cgImage: toCGImage, options: nil).oriented(.downMirrored)
                effect.transition.duration = transitionDuration
                effect.transition.transition(from: from, to: to, updater: { image in
                    
                }) { success in
                    print(success)
                    seamphore.signal()
                }
                seamphore.wait()
            }
        }
    }
}
