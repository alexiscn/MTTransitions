//
//  CALayer+Extensions.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/22.
//

import UIKit

extension CALayer {
    var snapshot: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
            guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
            self.render(in: ctx)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
