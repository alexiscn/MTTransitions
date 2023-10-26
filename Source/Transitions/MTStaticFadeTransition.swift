//
//  MTStaticFadeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2023/10/26.
//

import Foundation

public class MTStaticFadeTransition: MTTransition {
    
    public var nNoisePixels: Float = 200.0
 
    public var staticLuminosity: Float = 0.8
    
    override var fragmentName: String {
        return "StaticFadeFragment"
    }
    
    override var parameters: [String: Any] {
        return [
            "nNoisePixels": nNoisePixels,
            "staticLuminosity": staticLuminosity
        ]
    }
}
