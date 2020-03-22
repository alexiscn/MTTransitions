//
//  MTSwapTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTSwapTransition: MTTransition {
    
    public var depth: Float = 3 

    public var reflection: Float = 0.4 

    public var perspective: Float = 0.2 

    override var fragmentName: String {
        return "SwapFragment"
    }

    override var parameters: [String: Any] {
        return [
            "depth": depth, 
            "reflection": reflection, 
            "perspective": perspective
        ]
    }
}
