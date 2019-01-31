//
//  MTDreamyZoomTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDreamyZoomTransition: MTTransition {
    
    public var rotation: Float = 6 

    public var scale: Float = 1.2 

    override var fragmentName: String {
        return "DreamyZoomFragment"
    }

    override var parameters: [String: Any] {
        return [
            "rotation": rotation, 
            "scale": scale
        ]
    }
}
