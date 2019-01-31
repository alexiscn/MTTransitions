//
//  MTSimpleZoomTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTSimpleZoomTransition: MTTransition {
    
    public var zoom_quickness: Float = 0.8 

    override var fragmentName: String {
        return "SimpleZoomFragment"
    }

    override var parameters: [String: Any] {
        return [
            "zoom_quickness": zoom_quickness
        ]
    }
}
