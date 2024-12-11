//
//  MTParametricGlitchTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2024/12/11.
//

import Foundation

public class MTParametricGlitchTransition: MTTransition {

    public var ampx: Float = 1.0
    
    public var ampy: Float = 1.0

    override var fragmentName: String {
        return "ParametricGlitchFragment"
    }

    override var parameters: [String: Any] {
        return [
            "ampx": ampx,
            "ampy": ampy
        ]
    }
}
