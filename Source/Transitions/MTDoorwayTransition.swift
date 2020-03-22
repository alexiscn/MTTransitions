//
//  MTDoorwayTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDoorwayTransition: MTTransition {
    
    public var depth: Float = 3 

    public var reflection: Float = 0.4 

    public var perspective: Float = 0.4 

    override var fragmentName: String {
        return "DoorwayFragment"
    }

    override var parameters: [String: Any] {
        return [
            "depth": depth, 
            "reflection": reflection, 
            "perspective": perspective
        ]
    }
}
