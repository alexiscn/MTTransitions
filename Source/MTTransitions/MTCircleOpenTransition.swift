//
//  MTCircleOpenTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTCircleOpenTransition: MTTransition {
    
    public var smoothness: Float = 0.3 

    public var opening: Bool = true 

    override var fragmentName: String {
        return "CircleOpenFragment"
    }

    override var parameters: [String: Any] {
        return [
            "smoothness": smoothness, 
            "opening": opening
        ]
    }
}
