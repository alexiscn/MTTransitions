//
//  MTPolar_functionTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTPolar_functionTransition: MTTransition {
    
    public var segments: Int = 5 

    override var fragmentName: String {
        return "Polar_functionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "segments": segments
        ]
    }
}
