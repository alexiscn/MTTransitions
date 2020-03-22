//
//  MTVideoCompositor.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/22.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import AVFoundation

class MTVideoCompositor: NSObject, AVVideoCompositing {
    
    /// Returns the pixel buffer attributes required by the video compositor for new buffers created for processing.
    var requiredPixelBufferAttributesForRenderContext: [String : Any] =
    [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
    
    /// The pixel buffer attributes of pixel buffers that will be vended by the adaptor’s CVPixelBufferPool.
    var sourcePixelBufferAttributes: [String : Any]? =
    [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
    
    /// Set if all pending requests have been cancelled.
    var shouldCancelAllRequests = false
    
    /// Dispatch Queue used to issue custom compositor rendering work requests.
    private let renderingQueue = DispatchQueue(label: "me.shuifeng.mttransitions.renderingqueue")
    
    /// Dispatch Queue used to synchronize notifications that the composition will switch to a different render context.
    private let renderContextQueue = DispatchQueue(label: "me.shuifeng.mttransitions.rendercontextqueue")
    
    /// The current render context within which the custom compositor will render new output pixels buffers.
    private var renderContext: AVVideoCompositionRenderContext?
    
    /// Maintain the state of render context changes.
    private var internalRenderContextDidChange = false
    /// Actual state of render context changes.
    private var renderContextDidChange: Bool {
        get {
            return renderContextQueue.sync { internalRenderContextDidChange }
        }
        set (newRenderContextDidChange) {
            renderContextQueue.sync { internalRenderContextDidChange = newRenderContextDidChange }
        }
    }
    
    init(render: String) {
        super.init()
    }
    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
        renderContextQueue.sync { renderContext = newRenderContext }
        renderContextDidChange = true
    }
    
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        
    }
    
    func cancelAllPendingVideoCompositionRequests() {
        /*
         Pending requests will call finishCancelledRequest, those already rendering will call
         finishWithComposedVideoFrame.
         */
        renderingQueue.sync { shouldCancelAllRequests = true }
        renderingQueue.async {
            // Start accepting requests again.
            self.shouldCancelAllRequests = false
        }
    }
}
