//
//  MTPerlinTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTPerlinTransition: MTTransition {
    
    public var scale: Float = 4 

    public var seed: Float = 12.9898 

    public var smoothness: Float = 0.01 

    override var fragmentName: String {
        return "PerlinFragment"
    }

    override var parameters: [String: Any] {
        return [
            "scale": scale, 
            "seed": seed, 
            "smoothness": smoothness
        ]
    }
}
