//
//  MTColorphaseTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTColorphaseTransition: MTTransition {
    
    public var fromStep: UIColor = UIColor.white 

    public var toStep: UIColor = UIColor.white 

    override var fragmentName: String {
        return "ColorphaseFragment"
    }

    override var parameters: [String: Any] {
        return [
            "fromStep": fromStep, 
            "toStep": toStep
        ]
    }
}
