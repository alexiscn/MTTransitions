//
//  MTDissolveTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2023/10/26.
//

import Foundation
import simd

public class MTDissolveTransition: MTTransition {
    
    public var uLineWidth: Float = 0.1
    
    public var uSpreadClr: SIMD3<Float> = SIMD3<Float>(1.0, 0.0, 0.0)
    
    public var uHotClr: SIMD3<Float> = SIMD3<Float>(0.9, 0.9, 0.2)
    
    public var uPow: Float = 5.0
    
    public var uIntensity: Float = 1.0
    
    override var fragmentName: String {
        return "DissolveFragment"
    }
    
    override var parameters: [String : Any] {
        return [
            "uLineWidth": uLineWidth,
            "uSpreadClr": uSpreadClr,
            "uHotClr": uHotClr,
            "uPow": uPow,
            "uIntensity": uIntensity
        ]
    }
}
