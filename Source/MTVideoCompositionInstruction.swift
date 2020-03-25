//
//  MTVideoCompositionInstruction.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/23.
//

import Foundation
import AVFoundation

class MTVideoCompositionInstruction: NSObject, AVVideoCompositionInstructionProtocol {
    
    /// ID used to identify the foreground frame.
    var foregroundTrackID: CMPersistentTrackID = kCMPersistentTrackID_Invalid
    
    /// ID used to identify the background frame.
    var backgroundTrackID: CMPersistentTrackID = kCMPersistentTrackID_Invalid
    
    /// Effect applied to video transition
    var effect: MTTransition.Effect = .angular
    
    var timeRange: CMTimeRange {
        get { return self.overrideTimeRange }
        set { self.overrideTimeRange = newValue }
    }
    
    var enablePostProcessing: Bool {
        get { return self.overrideEnablePostProcessing }
        set { self.overrideEnablePostProcessing = newValue }
    }
    
    var containsTweening: Bool {
        get { return self.overrideContainsTweening }
        set { self.overrideContainsTweening = newValue }
    }
    
    var requiredSourceTrackIDs: [NSValue]? {
        get { return self.overrideRequiredSourceTrackIDs }
        set { self.overrideRequiredSourceTrackIDs = newValue }
    }
    
    var passthroughTrackID: CMPersistentTrackID {
        get { return self.overridePassthroughTrackID }
        set { self.overridePassthroughTrackID = newValue }
    }
    
    /// The timeRange during which instructions will be effective.
    private var overrideTimeRange: CMTimeRange = CMTimeRange()
    
    /// Indicates whether post-processing should be skipped for the duration of the instruction.
    private var overrideEnablePostProcessing = false
    
    /// Indicates whether to avoid some duplicate processing when rendering a frame from the same source and destinatin at different times.
    private var overrideContainsTweening = false
    
    /// The track IDs required to compose frames for the instruction.
    private var overrideRequiredSourceTrackIDs: [NSValue]?
    
    /// Track ID of the source frame when passthrough is in effect.
    private var overridePassthroughTrackID: CMPersistentTrackID = 0
    
    init(thePassthroughTrackID: CMPersistentTrackID, forTimeRange theTimeRange: CMTimeRange) {
        super.init()
        passthroughTrackID = thePassthroughTrackID
        timeRange = theTimeRange

        requiredSourceTrackIDs = [NSValue]()
        containsTweening = false
        enablePostProcessing = false
    }
    
    init(theSourceTrackIDs: [NSValue], forTimeRange theTimeRange: CMTimeRange) {
        super.init()

        requiredSourceTrackIDs = theSourceTrackIDs
        timeRange = theTimeRange

        passthroughTrackID = kCMPersistentTrackID_Invalid
        containsTweening = true
        enablePostProcessing = false
    }
}
