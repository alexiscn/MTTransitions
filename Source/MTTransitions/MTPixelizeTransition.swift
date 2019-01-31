//
//  MTPixelizeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTPixelizeTransition: MTTransition {
    
    public var squaresMin: CGSize = CGSize(width: 10, height: 10) 

    public var steps: Int = 50 

    override var fragmentName: String {
        return "PixelizeFragment"
    }
}
