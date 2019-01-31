//
//  MTGridFlipTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTGridFlipTransition: MTTransition {
    
    public var bgcolor: UIColor = UIColor.white 

    public var randomness: Float = 0.1 

    public var pause: Float = 0.1 

    public var dividerWidth: Float = 0.05 

    public var size: CGSize = CGSize(width: 10, height: 10) 

    override var fragmentName: String {
        return "GridFlipFragment"
    }

    override var parameters: [String: Any] {
        return [
            "bgcolor": bgcolor, 
            "randomness": randomness, 
            "pause": pause, 
            "dividerWidth": dividerWidth, 
            "size": size
        ]
    }
}
