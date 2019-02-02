//
//  MTRandomSquaresTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTRandomSquaresTransition: MTTransition {
    
    public var smoothness: Float = 0.5 

    public var size: CGSize = CGSize(width: 10, height: 10) 

    override var fragmentName: String {
        return "RandomSquaresFragment"
    }

    override var parameters: [String: Any] {
        return [
            "smoothness": smoothness, 
            "size": MTIVector(value: size)
        ]
    }
}
