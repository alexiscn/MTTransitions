//
//  MTLuminance_meltTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTLuminance_meltTransition: MTTransition {
    
    public var direction: Bool = True 

    public var above: Bool = False 

    public var l_threshold: Float = 0.8 

    override var fragmentName: String {
        return "Luminance_meltFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": direction, 
            "above": above, 
            "l_threshold": l_threshold
        ]
    }
}
