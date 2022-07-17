//
//  MTMosaicYueDevTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2022/7/8.
//

import Foundation

class MTMosaicYueDevTransition: MTTransition {
    
    public var mosaicNum: Float = 10
    
    override var fragmentName: String {
        return "MosaicYueDevFragment"
    }
    
    override var parameters: [String: Any] {
        return [ "mosaicNum": mosaicNum ]
    }
}
