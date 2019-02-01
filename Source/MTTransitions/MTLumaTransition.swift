//
//  MTLumaTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

// TODO
public class MTLumaTransition: MTTransition {
    
    override var fragmentName: String {
        return "LumaFragment"
    }
    
    override var samplers: [String : String] {
        return [
            "luma": "spiral-1.png"
        ]
    }
}
