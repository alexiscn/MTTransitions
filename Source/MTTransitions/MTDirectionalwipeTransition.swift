//
//  MTDirectionalwipeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDirectionalwipeTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0, y: 0) 

    public var smoothness: Float = 0.5 

    override var fragmentName: String {
        return "DirectionalwipeFragment"
    }
}
