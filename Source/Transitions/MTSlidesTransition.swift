//
//  MTSlidesTransition.swift
//  MTTransitions
//
//  Created by Nazmul on 04/08/2022.
//

import Foundation

public class MTSlidesTransition: MTTransition {
    
    public var type: Int = 2 //0 - 8

    public var In: Bool = false //
    
    // type: slide to/from which edge, which corner, or center
    // In: if true slide new image in, otherwise slide old image out

    override var fragmentName: String {
        return "SlidesFragment"
    }

    override var parameters: [String: Any] {
        return [
            "type": type,
            "In": In,
        ]
    }
}
