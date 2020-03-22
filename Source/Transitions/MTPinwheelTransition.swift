//
//  MTPinwheelTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTPinwheelTransition: MTTransition {
    
    public var speed: Float = 2 

    override var fragmentName: String {
        return "PinwheelFragment"
    }

    override var parameters: [String: Any] {
        return [
            "speed": speed
        ]
    }
}
