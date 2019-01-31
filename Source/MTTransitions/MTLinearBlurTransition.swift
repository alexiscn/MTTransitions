//
//  MTLinearBlurTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTLinearBlurTransition: MTTransition {
    
    public var intensity: Float = 0.1 

    override var fragmentName: String {
        return "LinearBlurFragment"
    }

    override var parameters: [String: Any] {
        return [
            "intensity": intensity
        ]
    }
}
