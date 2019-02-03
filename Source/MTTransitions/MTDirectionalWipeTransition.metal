// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 DirectionalWipeFragment(VertexOut vertexIn [[ stage_in ]],
                                        texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                        constant float2 & direction [[ buffer(0) ]],
                                        constant float & smoothness [[ buffer(1) ]],
                                        constant float & ratio [[ buffer(2) ]],
                                        constant float & progress [[ buffer(3) ]],
                                        sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    const float2 center = float2(0.5, 0.5);
    
    float2 v = normalize(direction);
    v /= abs(v.x)+abs(v.y);
    float d = v.x * center.x + v.y * center.y;
    float m =
    (1.0-step(progress, 0.0)) * // there is something wrong with our formula that makes m not equals 0.0 with progress is 0.0
    (1.0 - smoothstep(-smoothness, 0.0, v.x * uv.x + v.y * uv.y - (d-0.5+progress*(1.+smoothness))));
    
    return mix(getFromColor(uv, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               m);
}

