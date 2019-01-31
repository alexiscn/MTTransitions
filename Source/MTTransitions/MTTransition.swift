//
//  MTTransition.swift
//  MTTransitions
//
//  Created by xu.shuifeng on 2019/1/24.
//

import Foundation
import MetalPetal

public class MTTransition: NSObject, MTIUnaryFilter {
    
    public override init() { }
    
    public var inputImage: MTIImage?
    
    public var destImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    public var progress: Float = 0.0
    
    var fragmentName: String { return "" }
    
    var parameters: [String: Any] { return [:] }
    
    public var outputImage: MTIImage? {
        guard let input = inputImage, let dest = destImage else {
            return inputImage
        }
        let images: [MTIImage] = [input, dest]
        let outputDescriptors = [ MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]
        
        var params = parameters
        params["ratio"] = Float(512.0/400.0)
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
}
