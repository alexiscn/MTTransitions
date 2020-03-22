//
//  MTSqueezeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTSqueezeTransition: MTTransition {
    
    public var colorSeparation: Float = 0.04 

    override var fragmentName: String {
        return "SqueezeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "colorSeparation": colorSeparation
        ]
    }
}
