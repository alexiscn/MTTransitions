//
//  MTTVStaticTransition.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/24.
//

import Foundation

public class MTTVStaticTransition: MTTransition {
    
    public var offset: Float = 0.02
    
    override var fragmentName: String {
        return "TVStaticFragment"
    }
    
    override var parameters: [String: Any] {
        return [ "offset": offset ]
    }
}
