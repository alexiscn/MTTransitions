//
//  MTBounceTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTBounceTransition: MTTransition {
    
    public var bounces: Float = 3 

    public var shadowColour: UIColor = UIColor.white

    public var shadowHeight: Float = 0.075 

    override var fragmentName: String {
        return "BounceFragment"
    }
}
