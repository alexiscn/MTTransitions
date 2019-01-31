//
//  MTDreamyZoomTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDreamyZoomTransition: MTTransition {
    
    // In degrees
    public var rotation: Float = 6 

    // Multiplier
    public var scale: Float = 1.2 

    override var fragmentName: String {
        return "DreamyZoomFragment"
    }
}
