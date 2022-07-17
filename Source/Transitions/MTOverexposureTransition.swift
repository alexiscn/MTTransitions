//
//  MTOverexposureTransition.swift
//  MTTransitions
//
//  Created by alexis on 2022/4/9.
//


public class MTOverexposureTransition: MTTransition {

    public var strength: Float = 0.6

    override var fragmentName: String {
        return "OverexposureFragment"
    }

    override var parameters: [String: Any] {
        return [
            "strength": strength
        ]
    }
}
