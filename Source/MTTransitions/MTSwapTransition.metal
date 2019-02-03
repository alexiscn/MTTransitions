// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

bool swap_inBounds (float2 p) {
    const float2 boundMin = float2(0.0, 0.0);
    const float2 boundMax = float2(1.0, 1.0);
    return all(boundMin < p) && all(p < boundMax);
}

float2 swap_project (float2 p) {
    return p * float2(1.0, -1.2) + float2(0.0, -0.02);
}

fragment float4 SwapFragment(VertexOut vertexIn [[ stage_in ]],
                             texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                             texture2d<float, access::sample> toTexture [[ texture(1) ]],
                             constant float & depth [[ buffer(0) ]],
                             constant float & reflection [[ buffer(1) ]],
                             constant float & perspective [[ buffer(2) ]],
                             constant float & ratio [[ buffer(3) ]],
                             constant float & progress [[ buffer(4) ]],
                             sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 pfr, pto = float2(-1.);
    
    float size = mix(1.0, depth, progress);
    float persp = perspective * progress;
    pfr = (uv + float2(-0.0, -0.5)) * float2(size/(1.0 - perspective*progress), size/(1.0 - size * persp * uv.x)) + float2(0.0, 0.5);
    
    size = mix(1.0, depth, 1.-progress);
    persp = perspective * (1.-progress);
    pto = (uv + float2(-1.0, -0.5)) * float2(size/(1.0-perspective*(1.0-progress)), size/(1.0-size*persp*(0.5-uv.x))) + float2(1.0, 0.5);
    
    if (progress < 0.5) {
        if (swap_inBounds(pfr)) {
            return getFromColor(pfr, fromTexture, ratio, _fromR);
        }
        if (swap_inBounds(pto)) {
            return getToColor(pto, toTexture, ratio, _toR);
        }
    }
    if (swap_inBounds(pto)) {
        return getToColor(pto, toTexture, ratio, _toR);
    }
    if (swap_inBounds(pfr)) {
        return getFromColor(pfr, fromTexture, ratio, _fromR);
    }
    
    const float4 black = float4(0.0, 0.0, 0.0, 1.0);
    float4 c = black;
    pfr = swap_project(pfr);
    if (swap_inBounds(pfr)) {
        c += mix(black, getFromColor(pfr, fromTexture, ratio, _fromR), reflection * mix(1.0, 0.0, pfr.y));
    }
    pto = swap_project(pto);
    if (swap_inBounds(pto)) {
        c += mix(black, getToColor(pto, toTexture, ratio, _toR), reflection * mix(1.0, 0.0, pto.y));
    }
    return c;
}
