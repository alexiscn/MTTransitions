//
//  MTAngularTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTAngularTransition: MTTransition {
    
    public var startingAngle: Float = 90 

    override var fragmentName: String {
        return "AngularFragment"
    }
}
