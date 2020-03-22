//
//  MTFlyeyeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTFlyeyeTransition: MTTransition {
    
    public var colorSeparation: Float = 0.3 

    public var zoom: Float = 50 

    public var size: Float = 0.04 

    override var fragmentName: String {
        return "FlyeyeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "colorSeparation": colorSeparation, 
            "zoom": zoom, 
            "size": size
        ]
    }
}
