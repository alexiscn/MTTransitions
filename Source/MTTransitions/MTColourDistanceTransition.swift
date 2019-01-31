//
//  MTColourDistanceTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTColourDistanceTransition: MTTransition {
    
    public var power: Float = 5 

    override var fragmentName: String {
        return "ColourDistanceFragment"
    }

    override var parameters: [String: Any] {
        return [
            "power": power
        ]
    }
}
