//
//  MTRippleTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTRippleTransition: MTTransition {
    
    public var speed: Float = 50 

    public var amplitude: Float = 100 

    override var fragmentName: String {
        return "RippleFragment"
    }

    override var parameters: [String: Any] {
        return [
            "speed": speed, 
            "amplitude": amplitude
        ]
    }
}
