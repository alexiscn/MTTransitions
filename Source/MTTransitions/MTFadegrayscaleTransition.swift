//
//  MTFadegrayscaleTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTFadegrayscaleTransition: MTTransition {
    
    public var intensity: Float = 0.3 

    override var fragmentName: String {
        return "FadegrayscaleFragment"
    }
}
