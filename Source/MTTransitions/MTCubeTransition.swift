//
//  MTCubeTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTCubeTransition: MTTransition {
    
    public var persp: Float = 0.7 

    public var unzoom: Float = 0.3 

    public var reflection: Float = 0.4 

    public var floating: Float = 3 

    override var fragmentName: String {
        return "CubeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "persp": persp, 
            "unzoom": unzoom, 
            "reflection": reflection, 
            "floating": floating
        ]
    }
}
