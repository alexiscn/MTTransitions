//
//  MTViewControllerTransition.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/22.
//

import Foundation
import MetalPetal

public final class MTViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    private let transition: MTTransition
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        let fromSnapShotImage = containerView.layer.snapshot
        
        fromView.alpha = 0
        toView.frame = transitionContext.finalFrame(for: toVC)
        containerView.addSubview(toView)
        let toSnapShotImage = containerView.layer.snapshot
        
        guard let fromImage = mtiImage(from: fromSnapShotImage?.cgImage), let toImage = mtiImage(from: toSnapShotImage?.cgImage) else {
            transitionContext.completeTransition(true)
            return
        }
        fromView.alpha = 1
        toView.alpha = 0
        
        let renderView = MTIImageView(frame: containerView.bounds)
        renderView.clearColor = MTLClearColorMake(0, 0, 0, 0)
        renderView.isOpaque = false
        containerView.addSubview(renderView)
        
        transition.transition(from: fromImage, to: toImage, updater: { image in
            fromView.alpha = 0
            toView.alpha = 0
            renderView.image = image
        }) { _ in
            fromView.alpha = 1
            toView.alpha = 1
            renderView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    private func mtiImage(from cgImage: CGImage?) -> MTIImage? {
        guard let image = cgImage else { return nil }
        return MTIImage(cgImage: image, options: [.SRGB: false], isOpaque: false).oriented(.downMirrored).unpremultiplyingAlpha()
    }
    
    public init(transition: MTTransition, duration: TimeInterval = 0.8) {
        self.duration = duration
        self.transition = transition
        self.transition.duration = duration
    }
    
    public init(effect: MTTransition.Effect, duration: TimeInterval = 0.8) {
        self.duration = duration
        self.transition = effect.transition
        self.transition.duration = duration
    }
}
