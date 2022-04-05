//
//  MTPowerKaleidoTransition.swift
//  MTTransitions
//
//  Created by alexis on 2022/4/5.
//

import Foundation

public class MTPowerKaleidoTransition: MTTransition {
    
    public var scale: Float = 2.0

    public var z: Float = 1.5

    public var speed: Float = 5.0

    override var fragmentName: String {
        return "PowerKaleidoFragment"
    }

    override var parameters: [String: Any] {
        return [
            "scale": scale,
            "z": z,
            "speed": speed
        ]
    }
}
