//
//  MTTransition.swift
//  MTTransitions
//
//  Created by xu.shuifeng on 2019/1/24.
//

import Foundation
import MetalPetal

/// The callback when transition updated
public typealias MTTransitionUpdater = (_ image: MTIImage) -> Void

/// The callback when transition completed
public typealias MTTransitionCompletion = (_ finished: Bool) -> Void

public class MTTransition: NSObject, MTIUnaryFilter {
    
    public override init() { }
    
    public var inputImage: MTIImage?
    
    public var destImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    public var progress: Float = 0.0
    
    public var duration: TimeInterval = 1.2
    
    private var updater: MTTransitionUpdater?
    private var completion: MTTransitionCompletion?
    private weak var driver: CADisplayLink?
    private var startTime: TimeInterval?
    
    // Subclasses must provide fragmentName
    var fragmentName: String { return "" }
    var parameters: [String: Any] { return [:] }
    var samplers: [String: String] { return [:] }
    
    public var outputImage: MTIImage? {
        guard let input = inputImage, let dest = destImage else {
            return inputImage
        }
        var images: [MTIImage] = [input, dest]
        let outputDescriptors = [ MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]
        
        for key in samplers.keys {
            let name = samplers[key]!
            images.append(samplerImage(name: name)!)
        }
        
        var params = parameters
        params["ratio"] = Float(input.size.width / input.size.height)
        params["progress"] = progress
        
        let output = kernel.apply(toInputImages: images, parameters: params, outputDescriptors: outputDescriptors).first
        return output
    }
    
    var kernel: MTIRenderPipelineKernel {
        let vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        let fragmentDescriptor = MTIFunctionDescriptor(name: fragmentName, libraryURL: MTIDefaultLibraryURLForBundle(Bundle(for: MTTransition.self)))
        let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        return kernel
    }
    
    private func samplerImage(name: String) -> MTIImage? {
        let bundle = Bundle(for: MTTransition.self)
        let bundleUrl = bundle.url(forResource: "Assets", withExtension: "bundle")!
        let resourceBundle = Bundle(url: bundleUrl)!
        
        if let imageUrl = resourceBundle.url(forResource: name, withExtension: nil) {
            let ciImage = CIImage(contentsOf: imageUrl)
            return MTIImage(ciImage: ciImage!, isOpaque: true)
        }
        return nil
    }
    
    public func transition(from fromImage: MTIImage, to toImage: MTIImage, updater: @escaping MTTransitionUpdater, completion: MTTransitionCompletion?) {
        self.inputImage = fromImage
        self.destImage = toImage
        self.updater = updater
        self.completion = completion
        self.startTime = nil
        let driver = CADisplayLink(target: self, selector: #selector(render(sender:)))
        driver.add(to: .main, forMode: .common)
        driver.add(to: .main, forMode: .tracking)
        self.driver = driver
    }
    
    @objc private func render(sender: CADisplayLink) {
        let startTime: CFTimeInterval
        if let time = self.startTime {
            startTime = time
        } else {
            startTime = sender.timestamp
            self.startTime = startTime
        }
        
        let progress = (sender.timestamp - startTime) / duration
        if progress > 1 {
            self.progress = 1.0
            if let image = outputImage {
                self.updater?(image)
            }
            self.driver?.invalidate()
            self.driver = nil
            self.updater = nil
            self.completion?(true)
            self.completion = nil
            return
        }
        
        self.progress = Float(progress)
        if let image = outputImage {
            self.updater?(image)
        }
    }
    
    public func cancel() {
        self.completion?(false)
    }
}

extension MTTransition {

    private class var transitionLayerName: String { return "MTTransitionLayer" }
    
    public static func transition(with view: UIView, effect: MTTransition,
                                  animations: (() -> Void)?,
                                  completion: ((Bool) -> Void)? = nil) {
        guard let device = MTLCreateSystemDefaultDevice() else { completion?(false); return; }
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
                let context = try MTIContext.init(device: device)
                let transitionImage = try context.makeCGImage(from: img)
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
