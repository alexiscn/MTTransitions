//
//  MTDirectionalwarpTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTDirectionalwarpTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0, y: 0) 

    override var fragmentName: String {
        return "DirectionalwarpFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": MTIVector(value: direction)
        ]
    }
}
