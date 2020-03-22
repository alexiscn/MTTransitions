// License: MIT 
// Author: gre

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

bool doorway_inBounds (float2 p) {
    const float2 boundMin = float2(0.0, 0.0);
    const float2 boundMax = float2(1.0, 1.0);
    return all(boundMin < p) && all(p < boundMax);
}

float2 doorway_project (float2 p) {
    return p * float2(1.0, -1.2) + float2(0.0, -0.02);
}

float4 doorway_bgColor(float2 p, float2 pto, float reflection, texture2d<float, access::sample> toTexture, float ratio, float _toR) {
    const float4 black = float4(0.0, 0.0, 0.0, 1.0);
    float4 c = black;
    pto = doorway_project(pto);
    if (doorway_inBounds(pto)) {
        c += mix(black, getToColor(pto, toTexture, ratio, _toR), reflection * mix(1.0, 0.0, pto.y));
    }
    return c;
}

fragment float4 DoorwayFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    float2 pfr = float2(-1.), pto = float2(-1.);
    float middleSlit = 2.0 * abs(uv.x-0.5) - progress;
    if (middleSlit > 0.0) {
        pfr = uv + (uv.x > 0.5 ? -1.0 : 1.0) * float2(0.5 * progress, 0.0);
        float d = 1.0/(1.0 + perspective * progress*(1.0 - middleSlit));
        pfr.y -= d/2.0;
        pfr.y *= d;
        pfr.y += d/2.0;
    }
    float size = mix(1.0, depth, 1.0 - progress);
    pto = (uv + float2(-0.5, -0.5)) * float2(size, size) + float2(0.5, 0.5);
    if (doorway_inBounds(pfr)) {
        return getFromColor(pfr, fromTexture, ratio, _fromR);
    } else if (doorway_inBounds(pto)) {
        return getToColor(pto, toTexture, ratio, _toR);
    } else {
        return doorway_bgColor(uv, pto, reflection, toTexture, ratio, _toR);
    }
}

