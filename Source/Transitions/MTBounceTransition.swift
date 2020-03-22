//
//  MTBounceTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTBounceTransition: MTTransition {
    
    public var bounces: Float = 3 

    public var shadowColour: MTIColor = MTIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

    public var shadowHeight: Float = 0.075

    override var fragmentName: String {
        return "BounceFragment"
    }

    override var parameters: [String: Any] {
        return [
            "bounces": bounces, 
            "shadowColour": MTIVector(value: shadowColour.toFloat4()),
            "shadowHeight": shadowHeight
        ]
    }
}
