//
//  MTLissajousTilesTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2024/12/12.
//

import Foundation

public class MTLissajousTilesTransition: MTTransition {
 
    public var speed: Float = 0.5
    public var freq: CGPoint = CGPoint(x: 2.0, y: 3.0)
    public var offset: Float = 2.0
    public var zoom: Float = 0.8
    public var fade: Float = 0.8
 
    override var fragmentName: String {
        return "LissajousTilesFragment"
    }

    override var parameters: [String: Any] {
        return [
            "speed": speed,
            "offset": offset,
            "zoom": zoom,
            "fade": fade
        ]
    }
}
