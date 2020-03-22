//
//  MTSquaresWireTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTSquaresWireTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 1.0, y: -0.5) 

    public var squares: CGSize = CGSize(width: 10, height: 10) 

    public var smoothness: Float = 1.6 

    override var fragmentName: String {
        return "SquaresWireFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": MTIVector(value: direction),
            "squares": MTIVector(value: squares), 
            "smoothness": smoothness
        ]
    }
}
