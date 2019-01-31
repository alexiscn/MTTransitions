//
//  MTCrosshatchTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//
import MetalPetal

public class MTCrosshatchTransition: MTTransition {
    
    public var threshold: Float = 3 

    public var center: CGPoint = CGPoint(x: 0, y: 0) 

    public var fadeEdge: Float = 0.1 

    override var fragmentName: String {
        return "CrosshatchFragment"
    }

    override var parameters: [String: Any] {
        return [
            "threshold": threshold, 
            "center": MTIVector(value: center),
            "fadeEdge": fadeEdge
        ]
    }
}
