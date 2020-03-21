//
//  GIFGenerator.swift
//  https://github.com/eduardourso/GIFGenerator
//  MTTransitionsDemo
//
//  Created by xu.shuifeng on 2019/2/1.
//  Copyright © 2019 xu.shuifeng. All rights reserved.
//

import ImageIO
import MobileCoreServices
import AVFoundation
import Foundation
import UIKit

@objc open class GifGenerator: NSObject {
    
    var cmTimeArray:[NSValue] = []
    var framesArray:[UIImage] = []
    
    /**
     Generate a GIF using a set of images
     You can specify the loop count and the delays between the frames.
     
     :param: imagesArray an array of images
     :param: repeatCount the repeat count, defaults to 0 which is infinity
     :param: frameDelay an delay in seconds between each frame
     :param: callback set a block that will get called when done, it'll return with data and error, both which can be nil
     */
    open func generateGifFromImages(imagesArray:[UIImage], repeatCount: Int = 0, frameDelay: TimeInterval, destinationURL: URL, callback:@escaping (_ data: Data?, _ error: NSError?) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { () -> Void in
            
            if let imageDestination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, imagesArray.count, nil) {
                
                let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]] as CFDictionary
                let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: repeatCount]] as CFDictionary
                
                for image in imagesArray {
                    CGImageDestinationAddImage(imageDestination, image.cgImage!, frameProperties)
                }
                
                CGImageDestinationSetProperties(imageDestination, gifProperties)
                if CGImageDestinationFinalize(imageDestination) {
                    
                    do {
                        let data = try Data(contentsOf: destinationURL)
                        callback(data, nil)
                    } catch {
                        callback(nil, error as NSError)
                    }
                    
                } else {
                    callback(nil, self.errorFromString("Couldn't create the final image"))
                }
            }
        }
    }
    
    /**
     Generate a GIF using a set of video file (NSURL)
     You can specify the loop count and the delays between the frames.
     
     :param: videoURL an url where you video file is stored
     :param: repeatCount the repeat count, defaults to 0 which is infinity
     :param: frameDelay an delay in seconds between each frame
     :param: callback set a block that will get called when done, it'll return with data and error, both which can be nil
     */
    open func generateGifFromVideoURL(videoURL videoUrl:URL, repeatCount: Int = 0, framesInterval:Int, frameDelay: TimeInterval, destinationURL: URL, callback:@escaping (_ data: Data?, _ error: NSError?) -> ()) {
        
        self.generateFrames(videoUrl, framesInterval: framesInterval) { (images) -> () in
            if let images = images {
                self.generateGifFromImages(imagesArray: images, repeatCount: repeatCount, frameDelay: frameDelay, destinationURL: destinationURL, callback: { (data, error) -> () in
                    self.cmTimeArray = []
                    self.framesArray = []
                    callback(data, error)
                })
            }
        }
    }
    
    // MARK: THANKS TO: http://stackoverflow.com/questions/4001755/trying-to-understand-cmtime-and-cmtimemake
    fileprivate func generateFrames(_ url:URL, framesInterval:Int, callback:@escaping (_ images:[UIImage]?) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { () -> Void in
            self.generateCMTimesArrayOfFramesUsingAsset(framesInterval, asset: AVURLAsset(url: url))
            
            var i = 0
            let test = { (time1: CMTime, im: CGImage?, time2: CMTime, result: AVAssetImageGenerator.Result, error: Error?) in
                if(result == .succeeded) {
                    if let image = im {
                        self.framesArray.append(UIImage(cgImage: image))
                    }
                } else if (result == .failed) {
                    callback(nil);
                } else if (result == .cancelled) {
                    callback(nil);
                }
                i = i+1
                if(i == self.cmTimeArray.count) {
                    //Thumbnail generation completed
                    callback(self.framesArray)
                }
            } as AVAssetImageGeneratorCompletionHandler
            let generator = AVAssetImageGenerator(asset: AVAsset(url: url))
            generator.apertureMode = AVAssetImageGenerator.ApertureMode.cleanAperture
            generator.appliesPreferredTrackTransform = true
            generator.requestedTimeToleranceBefore = CMTime.zero
            generator.requestedTimeToleranceAfter = CMTime.zero
            
            generator.generateCGImagesAsynchronously(forTimes: self.cmTimeArray, completionHandler: test)
        }
    }
    
    fileprivate func generateCMTimesArrayOfAllFramesUsingAsset(_ asset:AVURLAsset) {
        if cmTimeArray.count > 0 {
            cmTimeArray.removeAll()
        }
        
        for t in 0 ..< asset.duration.value {
            let thumbTime = CMTimeMake(value: t, timescale: asset.duration.timescale)
            let value = NSValue(time: thumbTime)
            cmTimeArray.append(value)
        }
    }
    
    fileprivate func generateCMTimesArrayOfFramesUsingAsset(_ framesInterval:Int, asset:AVURLAsset) {
        
        let videoDuration = Int(ceilf((Float(Int(asset.duration.value)/Int(asset.duration.timescale)))))
        
        if cmTimeArray.count > 0 {
            cmTimeArray.removeAll()
        }
        
        for t in 0 ..< videoDuration {
            let tempInt = Int64(t)
            let tempCMTime = CMTimeMake(value: tempInt, timescale: asset.duration.timescale)
            let interval = Int32(framesInterval)
            
            for j in 1 ..< framesInterval+1 {
                let newCMtime = CMTimeMake(value: Int64(j), timescale: interval)
                let addition = CMTimeAdd(tempCMTime, newCMtime)
                cmTimeArray.append(NSValue(time: addition))
            }
        }
    }
    
    fileprivate func errorFromString(_ string: String, code: Int = -1) -> NSError {
        let dict = [NSLocalizedDescriptionKey: string]
        return NSError(domain: "org.cocoapods.GIFGenerator", code: code, userInfo: dict)
    }
}
