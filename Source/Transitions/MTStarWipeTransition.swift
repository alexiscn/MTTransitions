//
//  MTStarWipeTransition.swift
//  Pods
//
//  Created by alexiscn on 2024/12/11.
//

import Foundation
import MetalPetal

public class MTStarWipeTransition: MTTransition {
    
    public var boderThickness: Float = 0.01
 
    public var starRotation: Float = 0.75
    
    public var borderColor: MTIColor = MTIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    
    public var starCenter: CGPoint = CGPoint(x: 0.5, y: 0.5)
    
    override var fragmentName: String {
        return "StarWipeFragment"
    }
    
    override var parameters: [String: Any] {
        return [
            "boderThickness": boderThickness,
            "starRotation": starRotation,
            "borderColor": MTIVector(value: borderColor.toFloat4()),
            "starCenter": MTIVector(value: starCenter)
        ]
    }
}
