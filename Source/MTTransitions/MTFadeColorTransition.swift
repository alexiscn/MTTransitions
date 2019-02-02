//
//  MTFadeColorTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTFadeColorTransition: MTTransition {
    
    public var color: MTIColor = MTIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    /// if 0.0, there is no black phase, if 0.9, the black phase is very important
    public var colorPhase: Float = 0.4 

    override var fragmentName: String {
        return "FadeColorFragment"
    }

    override var parameters: [String: Any] {
        return [
            "color": MTIVector(value: simd_float3(color.red, color.green, color.blue)),
            "colorPhase": colorPhase
        ]
    }
}
