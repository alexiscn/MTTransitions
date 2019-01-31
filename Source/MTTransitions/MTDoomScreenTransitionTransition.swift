//
//  MTDoomScreenTransitionTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDoomScreenTransitionTransition: MTTransition {
    
    public var dripScale: Float = 0.5 

    public var bars: Int = 30 

    public var noise: Float = 0.1 

    public var frequency: Float = 0.5 

    public var amplitude: Float = 2 

    override var fragmentName: String {
        return "DoomScreenTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "dripScale": dripScale, 
            "bars": bars, 
            "noise": noise, 
            "frequency": frequency, 
            "amplitude": amplitude
        ]
    }
}
