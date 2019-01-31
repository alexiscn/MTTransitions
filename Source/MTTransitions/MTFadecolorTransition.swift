//
//  MTFadecolorTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTFadecolorTransition: MTTransition {
    
    public var color: UIColor = UIColor.white 

    public var colorPhase: Float = 0.4 

    override var fragmentName: String {
        return "FadecolorFragment"
    }

    override var parameters: [String: Any] {
        return [
            "color": color, 
            "colorPhase": colorPhase
        ]
    }
}
