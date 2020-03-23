//
//  MTVideoTransitionRenderer.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/23.
//

import Foundation
import MetalPetal

public class MTVideoTransitionRenderer: NSObject {
 
    private let effect: MTTransition.Effect
    
    private let context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    public init(effect: MTTransition.Effect) {
        self.effect = effect
        super.init()
    }
    
    public func renderPixelBuffer(_ destinationPixelBuffer: CVPixelBuffer,
                                  usingForegroundSourceBuffer foregroundPixelBuffer: CVPixelBuffer,
                                  andBackgroundSourceBuffer backgroundPixelBuffer: CVPixelBuffer,
                                  forTweenFactor tween: Float) {
        // TODO: - it seems current render is wrong
        let fromImage = MTIImage(cvPixelBuffer: foregroundPixelBuffer, alphaType: .alphaIsOne)
        let toImage = MTIImage(cvPixelBuffer: backgroundPixelBuffer, alphaType: .alphaIsOne)
        effect.transition.transition(from: fromImage, to: toImage, updater: { image in
            try? self.context?.render(image, to: destinationPixelBuffer)
        }, completion: nil)
    }
}
