//
//  MTRotate_scale_fadeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTRotate_scale_fadeTransition: MTTransition {
    
    public var scale: Float = 8 

    public var rotations: Float = 1 

    public var center: CGPoint = CGPoint(x: 0, y: 0) 

    public var backColor: UIColor = UIColor.white 

    override var fragmentName: String {
        return "Rotate_scale_fadeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "scale": scale, 
            "rotations": rotations, 
            "center": center, 
            "backColor": backColor
        ]
    }
}
