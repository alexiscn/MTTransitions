//
//  MTCrossHatchTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//
import MetalPetal

public class MTCrossHatchTransition: MTTransition {
    
    public var threshold: Float = 3 

    public var center: CGPoint = CGPoint(x: 0.5, y: 0.5) 

    public var fadeEdge: Float = 0.1 

    override var fragmentName: String {
        return "CrossHatchFragment"
    }

    override var parameters: [String: Any] {
        return [
            "threshold": threshold, 
            "center": MTIVector(value: center),
            "fadeEdge": fadeEdge
        ]
    }
}
