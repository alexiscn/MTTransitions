//
//  MTDisplacementTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDisplacementTransition: MTTransition {
    
    public var strength: Float = 0.5 

    override var fragmentName: String {
        return "DisplacementFragment"
    }

    override var parameters: [String: Any] {
        return [
            "strength": strength, 
           // "displacementMap": displacementMap
        ]
    }
}
