//
//  MTCrossZoomTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTCrossZoomTransition: MTTransition {
    
    public var strength: Float = 0.4 

    override var fragmentName: String {
        return "CrossZoomFragment"
    }

    override var parameters: [String: Any] {
        return [
            "strength": strength
        ]
    }
}
