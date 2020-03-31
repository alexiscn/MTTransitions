//
//  MTTransition+UIView.swift
//  MTTransitions
//
//  Created by endanke on 2020/3/24.
//

import Foundation
import MetalPetal

/// Make Transtion with UIView
extension MTTransition {
    
    private class var transitionLayerName: String { return "MTTransitionLayer" }
    
    public static func transition(with view: UIView, effect: MTTransition,
                                  animations: (() -> Void)?,
                                  completion: ((Bool) -> Void)? = nil) {
        // Check if effect is already in use
        guard effect.completion == nil else { completion?(false); return; }
        // Check if view has a transition in progress
        guard !(view.layer.sublayers ?? [] ).contains(where: { $0.name == transitionLayerName }) else {
            completion?(false); return;
        }
        
        var snapshotStart =  view.layer.snapshot
        let frameStart = view.layer.bounds
        animations?()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let frameEnd = view.layer.bounds
        
        // Check if frame size is valid
        guard frameStart.width > 0, frameStart.height > 0, frameEnd.width > 0, frameEnd.height > 0 else {
            completion?(false); return;
        }
        
        let layer = view.layer
        var snapshotEnd = layer.snapshot
        let originalLayers: [CALayer] = layer.sublayers ?? []
        let contents = layer.contents
        let transitionLayer = CALayer()
        transitionLayer.name = transitionLayerName
        
        // The frame of the start image should match the end image, so render the snapshots in the largest common area
        let commonSize = CGSize(width: max(frameStart.width, frameEnd.width),
                                height: max(frameStart.height, frameEnd.height))
        snapshotStart = snapshotStart?.imageWithSize(size: commonSize)
        snapshotEnd = snapshotEnd?.imageWithSize(size: commonSize)
        guard snapshotStart != nil, snapshotEnd != nil,
            let startCG = snapshotStart?.cgImage,
            let endCG = snapshotEnd?.cgImage else {
                completion?(false); return;
        }
        let imageA = MTIImage(cgImage: startCG, isOpaque: true).oriented(.downMirrored)
        let imageB = MTIImage(cgImage: endCG, isOpaque: true).oriented(.downMirrored)
        
        // Remove actual layer content while animating
        originalLayers.forEach { $0.removeFromSuperlayer() }
        layer.contents = []
        layer.addSublayer(transitionLayer)
        transitionLayer.drawsAsynchronously = true
        transitionLayer.contents = startCG
        transitionLayer.frame = CGRect(x: (commonSize.width - frameEnd.width) * -0.5,
                                       y: (commonSize.height - frameEnd.height) * -0.5,
                                       width: commonSize.width,
                                       height: commonSize.height)
        
        effect.transition(from: imageA, to: imageB, updater: { (img) in
            do {
                let transitionImage = try MTTransition.context?.makeCGImage(from: img)
                transitionLayer.contents = transitionImage
            } catch {}
        }, completion: { (_) in
            if (view.layer.sublayers ?? [] ).contains(where: { $0.name == transitionLayerName }) {
                clearTransition(view: view)
                originalLayers.forEach { view.layer.addSublayer($0) }
                view.layer.contents = contents
            } else {
                // Transition was cleared manually, do nothing
            }
            completion?(true)
        })
    }
    
    /// Manually clear the transition layer from a view. Useful in reusable components.
    public static func clearTransition(view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0.name == transitionLayerName })
    }
}
