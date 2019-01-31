//
//  MTButterflyWaveScrawlerTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTButterflyWaveScrawlerTransition: MTTransition {
    
    public var colorSeparation: Float = 0.3 

    public var amplitude: Float = 1 

    public var waves: Float = 30 

    override var fragmentName: String {
        return "ButterflyWaveScrawlerFragment"
    }

    override var parameters: [String: Any] {
        return [
            "colorSeparation": colorSeparation, 
            "amplitude": amplitude, 
            "waves": waves
        ]
    }
}
