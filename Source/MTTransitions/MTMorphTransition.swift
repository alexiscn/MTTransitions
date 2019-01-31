//
//  MTMorphTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTMorphTransition: MTTransition {
    
    public var strength: Float = 0.1 

    override var fragmentName: String {
        return "MorphFragment"
    }

    override var parameters: [String: Any] {
        return [
            "strength": strength
        ]
    }
}
