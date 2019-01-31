//
//  MTBounceTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTBounceTransition: MTTransition {
    
    public var bounces: Float = 3 

    public var shadow_colour: UIColor = UIColor.white 

    public var shadow_height: Float = 0.075 

    override var fragmentName: String {
        return "BounceFragment"
    }

    override var parameters: [String: Any] {
        return [
            "bounces": bounces, 
            "shadow_colour": shadow_colour, 
            "shadow_height": shadow_height
        ]
    }
}
