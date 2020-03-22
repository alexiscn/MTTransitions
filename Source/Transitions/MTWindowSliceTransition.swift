//
//  MTWindowsliceTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTWindowSliceTransition: MTTransition {
    
    public var count: Float = 10 

    public var smoothness: Float = 0.5 

    override var fragmentName: String {
        return "WindowSliceFragment"
    }

    override var parameters: [String: Any] {
        return [
            "count": count, 
            "smoothness": smoothness
        ]
    }
}
