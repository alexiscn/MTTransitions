//
//  MTHexagonalizeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTHexagonalizeTransition: MTTransition {
    
    public var steps: Int = 50 

    public var horizontalHexagons: Float = 20 

    override var fragmentName: String {
        return "HexagonalizeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "steps": Int32(steps), 
            "horizontalHexagons": horizontalHexagons
        ]
    }
}
