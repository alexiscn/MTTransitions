//
//  MTMosaicTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTMosaicTransition: MTTransition {
    
    public var endy: Int = -1 

    public var endx: Int = 2 

    override var fragmentName: String {
        return "MosaicFragment"
    }

    override var parameters: [String: Any] {
        return [
            "endy": Int32(endy),
            "endx": Int32(endx)
        ]
    }
}
