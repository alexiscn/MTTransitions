//
//  MTSquareswireTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTSquareswireTransition: MTTransition {
    
    public var direction: CGPoint = CGPoint(x: 0, y: 0) 

    public var squares: CGSize = CGSize(width: 10, height: 10) 

    public var smoothness: Float = 1.6 

    override var fragmentName: String {
        return "SquareswireFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": direction, 
            "squares": squares, 
            "smoothness": smoothness
        ]
    }
}
