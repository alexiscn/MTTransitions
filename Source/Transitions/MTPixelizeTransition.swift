//
//  MTPixelizeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal
import simd

public class MTPixelizeTransition: MTTransition {
    
    // minimum number of squares (when the effect is at its higher level)
    //public var squaresMin: int2 = int2(20, 20)
    public var squaresMin: SIMD2<Int32> = SIMD2(20, 20)
    
    // zero disable the stepping
    public var steps: Int = 50 

    override var fragmentName: String {
        return "PixelizeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "squaresMin": MTIVector(value: squaresMin),
            "steps": Int32(steps)
        ]
    }
}
