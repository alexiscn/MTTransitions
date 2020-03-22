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

class MTVideoTransition: NSObject {
    
    private var clips: [AVAsset] = []
    
    private var clipTimeRanges: [CMTime] = []
    
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
    
    public func makeTransition(with assets: [AVAsset], transition: MTTransition, completion: @escaping (() -> Void)) {
        self.clips.removeAll()
        self.clipTimeRanges.removeAll()
        loadAssetsKeys(assets: assets)
        // TODO
    }
    
    private func loadAssetsKeys(assets: [AVAsset]) {
        let assetKeys = ["tracks", "duration", "composable"]
        let dispatchGroup = DispatchGroup()
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
                dispatchGroup.leave()
            }
        }
    }
    
    private func makeTransitionInstructions(videoComposition: AVMutableVideoComposition,
                                            compositionVideoTracks: [AVMutableCompositionTrack]) {
        var instructions = [Any]()
        
        for index in 0 ..< clips.count {
            if videoComposition.customVideoCompositorClass != nil {
                let trackID = compositionVideoTracks[index].trackID
                let timeRange = passThroughTimeRanges[index]
                let videoInstruction = MTVideoCompositionInstruction(thePassthroughTrackID: trackID, forTimeRange: timeRange)
                instructions.append(videoInstruction)
            } else {
                // Pass through clip i.
                let passThroughInstruction = AVMutableVideoCompositionInstruction()
                passThroughInstruction.timeRange = passThroughTimeRanges[index]
                let passThroughLayer = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTracks[index])
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
                    if index == 0 {
                        // First track -> Foreground track while compositing.
                        videoInstruction.foregroundTrackID = compositionVideoTracks[index].trackID
                        // Second track -> Background track while compositing.
                        videoInstruction.backgroundTrackID =
                            compositionVideoTracks[1 - index].trackID
                    }
                    instructions.append(videoInstruction)
                } else {
                    let transitionInstruction = AVMutableVideoCompositionInstruction()
                    transitionInstruction.timeRange = transitionTimeRanges[index]
                    let fromLayer =
                        AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTracks[index])
                    let toLayer =
                        AVMutableVideoCompositionLayerInstruction(assetTrack:compositionVideoTracks[1 - index])
                    transitionInstruction.layerInstructions = [fromLayer, toLayer]
                    instructions.append(transitionInstruction)
                }
            }
        }
    }
    
}
