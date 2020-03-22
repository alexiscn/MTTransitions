//
//  MTPolar_functionTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTPolarFunctionTransition: MTTransition {
    
    public var segments: Int = 5 

    override var fragmentName: String {
        return "PolarFunctionFragment"
    }
    
    override var parameters: [String : Any] {
        return [
            "segments": Int32(segments)
        ]
    }
}
