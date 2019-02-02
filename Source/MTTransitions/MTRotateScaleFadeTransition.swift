//
//  MTRotate_scale_fadeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTRotateScaleFadeTransition: MTTransition {
    
    public var scale: Float = 8 

    public var rotations: Float = 1 

    public var center: CGPoint = CGPoint(x: 0.5, y: 0.5) 

    public var backColor: MTIColor = MTIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)

    override var fragmentName: String {
        return "RotateScaleFadeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "scale": scale, 
            "rotations": rotations, 
            "center": MTIVector(value: center), 
            "backColor": MTIVector(value: backColor.toFloat4())
        ]
    }
}
