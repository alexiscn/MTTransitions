//
//  MTGridFlipTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal
import simd

public class MTGridFlipTransition: MTTransition {
    
    public var bgcolor: MTIColor = MTIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    public var randomness: Float = 0.1 

    public var pause: Float = 0.1 

    public var dividerWidth: Float = 0.05 

    //public var size: int2 = int2(4, 4)
    public var size: SIMD2<Int32> = SIMD2(4, 4)

    override var fragmentName: String {
        return "GridFlipFragment"
    }

    override var parameters: [String: Any] {
        return [
            "bgcolor": MTIVector(value: bgcolor.toFloat4()), 
            "randomness": randomness, 
            "pause": pause, 
            "dividerWidth": dividerWidth, 
            "size": MTIVector(value: size)
        ]
    }
}
