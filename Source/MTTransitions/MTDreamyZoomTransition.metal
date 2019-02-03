// Author: Zeh Fernando
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

// Definitions --------
#define DEG2RAD 0.03926990816987241548078304229099 // 1/180*PI


fragment float4 DreamyZoomFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & rotation [[ buffer(0) ]],
                                   constant float & scale [[ buffer(1) ]],
                                   constant float & ratio [[ buffer(2) ]],
                                   constant float & progress [[ buffer(3) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    // Massage parameters
    float phase = progress < 0.5 ? progress * 2.0 : (progress - 0.5) * 2.0;
    float angleOffset = progress < 0.5 ? mix(0.0, rotation * DEG2RAD, phase) : mix(-rotation * DEG2RAD, 0.0, phase);
    float newScale = progress < 0.5 ? mix(1.0, scale, phase) : mix(scale, 1.0, phase);
    
    float2 center = float2(0, 0);
    
    // Calculate the source point
    //float2 assumedCenter = float2(0.5, 0.5);
    float2 p = (uv.xy - float2(0.5, 0.5)) / newScale * float2(ratio, 1.0);
    
    // This can probably be optimized (with distance())
    float angle = atan2(p.y, p.x) + angleOffset;
    float dist = distance(center, p);
    p.x = cos(angle) * dist / ratio + 0.5;
    p.y = sin(angle) * dist + 0.5;
    float4 c = progress < 0.5 ? getFromColor(p, fromTexture, ratio, _fromR) : getToColor(p, toTexture, ratio, _toR);

    // Finally, apply the color
    return c + (progress < 0.5 ? mix(0.0, 1.0, phase) : mix(1.0, 0.0, phase));
}
