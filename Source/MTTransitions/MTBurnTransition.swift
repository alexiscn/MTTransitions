//
//  MTBurnTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTBurnTransition: MTTransition {
    
    public var color: MTIColor = MTIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0)

    override var fragmentName: String {
        return "BurnFragment"
    }

    override var parameters: [String: Any] {
        return [
            "color": MTIVector(value: simd_float3(color.red, color.green, color.blue))
        ]
    }
}
