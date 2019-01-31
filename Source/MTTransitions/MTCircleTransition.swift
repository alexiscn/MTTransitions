//
//  MTCircleTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTCircleTransition: MTTransition {
    
    public var center: CGPoint = CGPoint(x: 0, y: 0) 

    public var backColor: UIColor = UIColor.white 

    override var fragmentName: String {
        return "CircleFragment"
    }
}
