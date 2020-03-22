//
//  MTVideoTransition.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/22.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import Foundation
import AVFoundation
import MTTransitions

public class MTVideoTransition: NSObject {
    
    /// The duration of the transition.
    public var transitionDuration: CMTime = .invalid
    
    private var clips: [AVAsset] = []
    
    private var clipTimeRanges: [CMTimeRange] = []
    
    /// The time range in which the clips should pass through.
    private lazy var passThroughTimeRanges: [CMTimeRange] = {
        let time = CMTime.zero
        return Array(repeating: CMTimeRangeMake(start: time, duration: time), count: clips.count)
    }()
    
    /// The transition time range for the clips.
    private lazy var transitionTimeRanges: [CMTimeRange] = {
        let time = CMTime.zero
        return Array(repeating: CMTimeRangeMake(start: time, duration: time), count: clips.count)
    }()
    
    public func makeTransition(with assets: [AVAsset], effect: MTTransition.Effect, completion: @escaping ((AVPlayerItem) -> Void)) {
        self.clips.removeAll()
        self.clipTimeRanges.removeAll()
        
        let dispatchGroup = DispatchGroup()
        loadAssetsKeys(assets: assets, usingDispatchGroup: dispatchGroup)
        dispatchGroup.notify(queue: .main) {
            self.doTranstionStaffs(completion: completion)
        }
    }
    
    private func doTranstionStaffs(completion: @escaping ((AVPlayerItem) -> Void)) {
        let videoTracks = self.clips[0].tracks(withMediaType: .video)
        let videoSize = videoTracks[0].naturalSize
        
        let composition = AVMutableComposition()
        composition.naturalSize = videoSize
        
        /*
         With transitions:
         Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
         Set up the video composition to cycle between "pass through A", "transition from A to B", "pass through B".
        */
        let videoComposition = AVMutableVideoComposition()
        videoComposition.customVideoCompositorClass = MTVideoCompositor.self
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30) // 30 fps.
        videoComposition.renderSize = videoSize
        
        self.buildTransitionComposition(composition, videoComposition: videoComposition)
        
        let playerItem = AVPlayerItem(asset: composition)
        playerItem.videoComposition = videoComposition
        completion(playerItem)
        
        // TODO: - export asset
        //export(composition: composition, videoComposition: videoComposition)
    }
    
    private func buildTransitionComposition(_ composition: AVMutableComposition, videoComposition: AVMutableVideoComposition) {
        
        // Add two video tracks and two audio tracks.
        var compositionVideoTracks =
            [composition.addMutableTrack(withMediaType: AVMediaType.video,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!,
             composition.addMutableTrack(withMediaType: AVMediaType.video,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!]
        var compositionAudioTracks =
            [composition.addMutableTrack(withMediaType: AVMediaType.audio,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!,
             composition.addMutableTrack(withMediaType: AVMediaType.audio,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!]

        buildComposition(compositionVideoTracks: &compositionVideoTracks, compositionAudioTracks: &compositionAudioTracks)
        let instructions = makeTransitionInstructions(videoComposition: videoComposition, compositionVideoTracks: compositionVideoTracks)
        guard let newInstructions = instructions as? [AVVideoCompositionInstructionProtocol] else {
            videoComposition.instructions = []
            return
        }
        videoComposition.instructions = newInstructions
    }
    
    private func loadAssetsKeys(assets: [AVAsset], usingDispatchGroup dispatchGroup: DispatchGroup) {
        let assetKeys = ["tracks", "duration", "composable"]
        
        for asset in assets {
            dispatchGroup.enter()
            asset.loadValuesAsynchronously(forKeys: assetKeys) {
                for key in assetKeys {
                    var error: NSError?
                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
                        dispatchGroup.leave()
                        return
                    }
                }
                if !asset.isComposable {
                    dispatchGroup.leave()
                }
                self.clips.append(asset)
                // TODO: - use actual time range
                self.clipTimeRanges.append(CMTimeRange(start: CMTimeMakeWithSeconds(0, preferredTimescale: 1),
                                                       duration: CMTimeMakeWithSeconds(5, preferredTimescale: 1)))
                dispatchGroup.leave()
            }
        }
    }
    
    private func buildComposition(compositionVideoTracks: inout [AVMutableCompositionTrack],
                                  compositionAudioTracks: inout [AVMutableCompositionTrack]) {
        
        // Make transitionDuration no greater than half the shortest clip duration.
        for timeRange in clipTimeRanges {
            var halfClipDuration = timeRange.duration
            // You can halve a rational by doubling its denominator.
            halfClipDuration.timescale *= 2
            transitionDuration = CMTimeMinimum(transitionDuration, halfClipDuration)
        }
        let clipsCount = clips.count
        var alternatingIndex = 0
        var nextClipStartTime = CMTime.zero
        
        for index in 0 ..< clipsCount {
            alternatingIndex = index % 2
            let asset = clips[index]
            var timeRangeInAsset: CMTimeRange
            if index < clipTimeRanges.count {
                timeRangeInAsset = clipTimeRanges[index]
            } else {
                timeRangeInAsset = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
            }
            
            do {
                if let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video).first {
                    try compositionVideoTracks[alternatingIndex].insertTimeRange(timeRangeInAsset, of: clipVideoTrack, at: nextClipStartTime)
                } else {
                    print("video track nil")
                }
                
                if let clipAudioTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
                    try compositionAudioTracks[alternatingIndex].insertTimeRange(timeRangeInAsset, of: clipAudioTrack, at: nextClipStartTime)
                } else {
                    print("audio track nil")
                }
            } catch {
                print("An error occurred inserting a time range of the source track into the composition.")
            }
            
            /*
             Remember the time range in which this clip should pass through.
             First clip ends with a transition.
             Second clip begins with a transition.
             Exclude that transition from the pass through time ranges.
             */
            passThroughTimeRanges[index] = CMTimeRangeMake(start: nextClipStartTime, duration: timeRangeInAsset.duration)
            if index > 0 {
                passThroughTimeRanges[index].start = CMTimeAdd(passThroughTimeRanges[index].start, transitionDuration)
                passThroughTimeRanges[index].duration = CMTimeSubtract(passThroughTimeRanges[index].duration, transitionDuration)
            }
            if index + 1 < clipsCount {
                passThroughTimeRanges[index].duration = CMTimeSubtract(passThroughTimeRanges[index].duration, transitionDuration)
            }
            
            /*
             The end of this clip will overlap the start of the next by transitionDuration.
             (Note: this arithmetic falls apart if timeRangeInAsset.duration < 2 * transitionDuration.)
             */
            nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration)
            nextClipStartTime = CMTimeSubtract(nextClipStartTime, transitionDuration)
            
            // Remember the time range for the transition to the next item.
            if index + 1 < clipsCount {
                transitionTimeRanges[index] = CMTimeRangeMake(start: nextClipStartTime, duration: transitionDuration)
            }
        }
    }
    
    private func makeTransitionInstructions(videoComposition: AVMutableVideoComposition,
                                            compositionVideoTracks: [AVMutableCompositionTrack]) -> [Any] {
        var alternatingIndex = 0
        var instructions = [Any]()
        
        for index in 0 ..< clips.count {
            alternatingIndex = index % 2
            if videoComposition.customVideoCompositorClass != nil {
                let trackID = compositionVideoTracks[alternatingIndex].trackID
                let timeRange = passThroughTimeRanges[index]
                let videoInstruction = MTVideoCompositionInstruction(thePassthroughTrackID: trackID, forTimeRange: timeRange)
                instructions.append(videoInstruction)
            } else {
                // Pass through clip i.
                let passThroughInstruction = AVMutableVideoCompositionInstruction()
                passThroughInstruction.timeRange = passThroughTimeRanges[index]
                let passThroughLayer = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTracks[alternatingIndex])
                passThroughInstruction.layerInstructions = [passThroughLayer]
                instructions.append(passThroughInstruction)
            }
            
            // Add transition from clip[i] to clip[i + 1]
            if index + 1 < clips.count {
                if videoComposition.customVideoCompositorClass != nil {
                    let trackIDs: [NSNumber] = [
                        NSNumber(value: compositionVideoTracks[0].trackID),
                        NSNumber(value: compositionVideoTracks[1].trackID)
                    ]
                    let timeRange = transitionTimeRanges[index]
                    let videoInstruction = MTVideoCompositionInstruction(theSourceTrackIDs: trackIDs, forTimeRange: timeRange)
                    if alternatingIndex == 0 {
                        // First track -> Foreground track while compositing.
                        videoInstruction.foregroundTrackID = compositionVideoTracks[alternatingIndex].trackID
                        // Second track -> Background track while compositing.
                        videoInstruction.backgroundTrackID =
                            compositionVideoTracks[1 - alternatingIndex].trackID
                    }
                    instructions.append(videoInstruction)
                } else {
                    let transitionInstruction = AVMutableVideoCompositionInstruction()
                    transitionInstruction.timeRange = transitionTimeRanges[index]
                    let fromLayer =
                        AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTracks[alternatingIndex])
                    let toLayer =
                        AVMutableVideoCompositionLayerInstruction(assetTrack:compositionVideoTracks[1 - alternatingIndex])
                    transitionInstruction.layerInstructions = [fromLayer, toLayer]
                    instructions.append(transitionInstruction)
                }
            }
        }
        return instructions
    }
    
    private func export(composition: AVMutableComposition, videoComposition: AVMutableVideoComposition) {
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        exportSession.videoComposition = videoComposition
        
        let filePath = NSTemporaryDirectory().appending("ExportedProject.mp4")
        print(filePath)
        let fileExists = FileManager.default.fileExists(atPath: filePath)
        if fileExists {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print("An error occured deleting the file: \(error)")
            }
        }
        exportSession.outputURL = URL(fileURLWithPath: filePath)
        exportSession.outputFileType = AVFileType.mp4
        exportSession.exportAsynchronously(completionHandler: {
            print(exportSession.error)
            print("exported")
        })
    }
    
}
