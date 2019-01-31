//
//  MTWaterDropTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTWaterDropTransition: MTTransition {
    
    public var speed: Float = 30 

    public var amplitude: Float = 30 

    override var fragmentName: String {
        return "WaterDropFragment"
    }

    override var parameters: [String: Any] {
        return [
            "speed": speed, 
            "amplitude": amplitude
        ]
    }
}
