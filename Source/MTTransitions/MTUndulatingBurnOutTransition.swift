//
//  MTUndulatingBurnOutTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTUndulatingBurnOutTransition: MTTransition {
    
    public var color: UIColor = UIColor.white 

    public var smoothness: Float = 0.03 

    public var center: CGPoint = CGPoint(x: 0, y: 0) 

    override var fragmentName: String {
        return "UndulatingBurnOutFragment"
    }

    override var parameters: [String: Any] {
        return [
            "color": color, 
            "smoothness": smoothness, 
            "center": center
        ]
    }
}
