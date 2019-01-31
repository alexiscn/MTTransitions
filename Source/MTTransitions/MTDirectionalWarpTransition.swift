//
//  MTDirectionalWarpTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDirectionalWarpTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0, y: 0) 

    override var fragmentName: String {
        return "DirectionalWarpFragment"
    }
}
