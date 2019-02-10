//
//  MTTransition.swift
//  MTTransitions
//
//  Created by xu.shuifeng on 2019/1/24.
//

import Foundation
import MetalPetal

public typealias MTTransitionUpdater = (_ image: MTIImage) -> Void

public typealias MTTransitionCompletion = (_ finished: Bool) -> Void

public class MTTransition: NSObject, MTIUnaryFilter {
    
    public override init() { }
    
    public var inputImage: MTIImage?
    
    private var destImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    public var progress: Float = 0.0
    
    public var duration: TimeInterval = 2.0
    
    public var ratio: Float = Float(512)/Float(400)
    
    private var updater: MTTransitionUpdater?
    private var completion: MTTransitionCompletion?
    private weak var driver: CADisplayLink?
    private var startTime: TimeInterval?
    
    internal var fragmentName: String { return "" }
    internal var parameters: [String: Any] { return [:] }
    internal var samplers: [String: String] { return [:] }
    
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
        params["ratio"] = ratio
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

public final class MTViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    private let transition: MTTransition
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to), let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, false, UIScreen.main.nativeScale)
        containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: true)
        let fromSnapShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()?.clear(containerView.bounds)
        
        fromView.alpha = 0
        toView.frame = transitionContext.finalFrame(for: toVC)
        containerView.addSubview(toView)
        containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: true)
        let toSnapShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
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
        
        fromView.alpha = 0
        
        transition.transition(from: fromImage, to: toImage, updater: { image in
            renderView.image = image
        }) { _ in
            fromView.alpha = 1
            toView.alpha = 1
            fromView.removeFromSuperview()
            renderView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    private func mtiImage(from cgImage: CGImage?) -> MTIImage? {
        guard let image = cgImage else { return nil }
        return MTIImage(cgImage: image, options: [.SRGB: false], isOpaque: false).unpremultiplyingAlpha()
    }
    
    public init(transition: MTTransition, duration: TimeInterval = 0.8) {
        self.duration = duration
        self.transition = transition
    }
    
}
