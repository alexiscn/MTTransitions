//
//  MTTransitions.h
//  MTTransitions
//
//  Created by xu.shuifeng on 2019/1/24.
//

#ifndef MTTransitions_h
#define MTTransitions_h

#if __METAL_MACOS__ || __METAL_IOS__

#define PI 3.141592653589
#define M_PI   3.14159265358979323846

#include <metal_stdlib>
#include "MTIShaderLib.h"

using namespace metal;

namespace metalpetal {
    
    enum class ResizeMode { cover, contains, stretch };
    
    METAL_FUNC float2 cover(float2 uv, float ratio, float r) {
        
        return 0.5 + (uv - 0.5) * float2(min(ratio/r, 1.0), min(r/ratio, 1.0));
    }
    
//    METAL_FUNC float2 resize(ResizeMode mode, float ratio, float2 uv, float4 texture) {
//        if (mode == ResizeMode::cover) {
//
//        } else if (mode == ResizeMode::contains) {
//
//        } else {
//            return uv;
//        }
//        return float2(1.0);
//    }
    
    METAL_FUNC float4 getFromColor(float2 uv, texture2d<float, access::sample> texture, float ratio, float _fromR) {
        constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
        float2 _uv = cover(uv, ratio, _fromR);
        return texture.sample(s, _uv);
    }
    
    METAL_FUNC float4 getToColor(float2 uv, texture2d<float, access::sample> texture, float ratio, float _toR) {
        constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
        float2 _uv = cover(uv, ratio, _toR);
        return texture.sample(s, _uv);
    }
    
    //Random function borrowed from everywhere
    METAL_FUNC float rand(float2 co){
      return fract(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
    }
}

#endif /* MTTransitions_h */

#endif
