//
//  MTPixelizeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTPixelizeTransition: MTTransition {
    
    public var squaresMin: CGSize = CGSize(width: 10, height: 10) 

    public var steps: Int = 50 

    override var fragmentName: String {
        return "PixelizeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "squaresMin": MTIVector(value: squaresMin), 
            "steps": steps
        ]
    }
}
