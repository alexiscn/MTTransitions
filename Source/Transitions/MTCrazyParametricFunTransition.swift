//
//  MTCrazyParametricFunTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTCrazyParametricFunTransition: MTTransition {
    
    public var a: Float = 4 

    public var b: Float = 1 

    public var smoothness: Float = 0.1 

    public var amplitude: Float = 120 

    override var fragmentName: String {
        return "CrazyParametricFunFragment"
    }

    override var parameters: [String: Any] {
        return [
            "a": a, 
            "b": b, 
            "smoothness": smoothness, 
            "amplitude": amplitude
        ]
    }
}
