//
//  MTColorPhaseTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTColorPhaseTransition: MTTransition {
    
    // Usage: fromStep and toStep must be in [0.0, 1.0] range
    // and all(fromStep) must be < all(toStep)
    public var fromStep: MTIColor = MTIColor(red: 0.0, green: 0.2, blue: 0.4, alpha: 0.0)

    public var toStep: MTIColor = MTIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0)

    override var fragmentName: String {
        return "ColorPhaseFragment"
    }

    override var parameters: [String: Any] {
        return [
            "fromStep": MTIVector(value: fromStep.toFloat4()),
            "toStep": MTIVector(value: toStep.toFloat4())
        ]
    }
}
