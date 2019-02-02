//
//  MTDirectionalTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTDirectionalTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0, y: 1.0) 

    override var fragmentName: String {
        return "DirectionalFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": MTIVector(value: direction)
        ]
    }
}
