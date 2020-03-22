//
//  MTKaleidoScopeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTKaleidoScopeTransition: MTTransition {
    
    public var angle: Float = 1 

    public var speed: Float = 1 

    public var power: Float = 1.5 

    override var fragmentName: String {
        return "KaleidoScopeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "angle": angle, 
            "speed": speed, 
            "power": power
        ]
    }
}
