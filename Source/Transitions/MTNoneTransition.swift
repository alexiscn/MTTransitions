//
//  MTNoneTransition.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/30.
//

import Foundation
import MetalPetal

/// None transition
public class MTNoneTransition: MTTransition {
    
    public override var outputImage: MTIImage? {
        // Just return toImage
        return destImage?.oriented(.downMirrored)
    }
    
    public override func transition(from fromImage: MTIImage, to toImage: MTIImage, updater: @escaping MTTransitionUpdater, completion: MTTransitionCompletion?) {
        updater(toImage.oriented(.downMirrored))
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?(true)
        }
    }
    
}
