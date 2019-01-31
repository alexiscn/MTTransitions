//
//  MTGridFlipTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTGridFlipTransition: MTTransition {
    
    public var bgcolor: MTIColor = MTIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    public var randomness: Float = 0.1 

    public var pause: Float = 0.1 

    public var dividerWidth: Float = 0.05 

    public var size: CGSize = CGSize(width: 10, height: 10) 

    override var fragmentName: String {
        return "GridFlipFragment"
    }

    override var parameters: [String: Any] {
        return [
            "bgcolor": MTIVector(value: bgcolor.toFloat4()), 
            "randomness": randomness, 
            "pause": pause, 
            "dividerWidth": dividerWidth, 
            "size": size
        ]
    }
}
