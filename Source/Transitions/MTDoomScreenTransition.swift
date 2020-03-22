//
//  MTDoomScreenTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTDoomScreenTransition: MTTransition {
    
    // How much the bars seem to "run" from the middle of the screen first (sticking to the sides). 0 = no drip, 1 = curved drip
    public var dripScale: Float = 0.5 

    // Number of total bars/columns
    public var bars: Int = 30 

    // Further variations in speed. 0 = no noise, 1 = super noisy (ignore frequency)
    public var noise: Float = 0.1 

    // Speed variation horizontally. the bigger the value, the shorter the waves
    public var frequency: Float = 0.5 

    // Multiplier for speed ratio. 0 = no variation when going down, higher = some elements go much faster
    public var amplitude: Float = 2 

    override var fragmentName: String {
        return "DoomScreenFragment"
    }

    override var parameters: [String: Any] {
        return [
            "dripScale": dripScale, 
            "bars": Int32(bars), 
            "noise": noise, 
            "frequency": frequency, 
            "amplitude": amplitude
        ]
    }
}
