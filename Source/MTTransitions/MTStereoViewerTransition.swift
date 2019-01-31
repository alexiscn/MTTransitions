//
//  MTStereoViewerTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTStereoViewerTransition: MTTransition {
    
    public var corner_radius: Float = 0.22 

    public var zoom: Float = 0.88 

    override var fragmentName: String {
        return "StereoViewerFragment"
    }

    override var parameters: [String: Any] {
        return [
            "corner_radius": corner_radius, 
            "zoom": zoom
        ]
    }
}
