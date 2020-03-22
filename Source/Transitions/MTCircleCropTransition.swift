//
//  MTCircleCropTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTCircleCropTransition: MTTransition {
    
    public var bgcolor: MTIColor = MTIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    override var fragmentName: String {
        return "CircleCropFragment"
    }

    override var parameters: [String: Any] {
        return [
            "bgcolor": MTIVector(value: bgcolor.toFloat4())
        ]
    }
}
