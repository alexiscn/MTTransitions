//
//  MTDirectionalwipeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTDirectionalwipeTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0, y: 0) 

    public var smoothness: Float = 0.5 

    override var fragmentName: String {
        return "DirectionalwipeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": MTIVector(value: direction), 
            "smoothness": smoothness
        ]
    }
}
