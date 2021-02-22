//
//  MTDirectionalEasingTransition.swift
//  MTTransitions
//
//  Created by xu.shuifeng on 2021/2/22.
//

import MetalPetal

public class MTDirectionalEasingTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0.0, y: 1.0)
    
    override var fragmentName: String {
        return "DirectionalEasingFragment"
    }
    
    override var parameters: [String: Any] {
        return [
            "direction": MTIVector(value: direction)
        ]
    }
}
