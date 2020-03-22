//
//  MTUndulatingBurnOutTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTUndulatingBurnOutTransition: MTTransition {
    
    public var color: MTIColor = MTIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    public var smoothness: Float = 0.03 

    public var center: CGPoint = CGPoint(x: 0.5, y: 0.5) 

    override var fragmentName: String {
        return "UndulatingBurnOutFragment"
    }

    override var parameters: [String: Any] {
        return [
            "color": MTIVector(value: simd_float3(color.red, color.green, color.blue)),
            "smoothness": smoothness, 
            "center": MTIVector(value: center)
        ]
    }
}
