//
//  MTRadialTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTRadialTransition: MTTransition {
    
    public var smoothness: Float = 1 

    override var fragmentName: String {
        return "RadialFragment"
    }

    override var parameters: [String: Any] {
        return [
            "smoothness": smoothness
        ]
    }
}
