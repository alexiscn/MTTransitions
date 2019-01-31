//
//  MTBurnTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTBurnTransition: MTTransition {
    
    public var color: UIColor = UIColor.white 

    override var fragmentName: String {
        return "BurnFragment"
    }

    override var parameters: [String: Any] {
        return [
            "color": color
        ]
    }
}
