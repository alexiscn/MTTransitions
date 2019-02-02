//
//  MTCircleTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

import MetalPetal

public class MTCircleTransition: MTTransition {
    
    public var center: CGPoint = CGPoint(x: 0.5, y: 0.5) 

    public var backColor: MTIColor = MTIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)

    override var fragmentName: String {
        return "CircleFragment"
    }

    override var parameters: [String: Any] {
        return [
            "center": MTIVector(value: center),
            "backColor": MTIVector(value: simd_float3(backColor.red, backColor.green, backColor.blue))
        ]
    }
}
