//
//  MTPolkaDotsCurtainTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTPolkaDotsCurtainTransition: MTTransition {
    
    public var dots: Float = 20 

    public var center: CGPoint = CGPoint(x: 0, y: 0) 

    override var fragmentName: String {
        return "PolkaDotsCurtainFragment"
    }

    override var parameters: [String: Any] {
        return [
            "dots": dots, 
            "center": MTIVector(value: center) 
        ]
    }
}
