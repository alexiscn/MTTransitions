// Author: Gaëtan Renaudeau
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 DirectionalFragment(VertexOut vertexIn [[ stage_in ]],
                                    texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                    texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                    constant float2 & direction [[ buffer(0) ]],
                                    constant float & ratio [[ buffer(1) ]],
                                    constant float & progress [[ buffer(2) ]],
                                    sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 p = uv + progress * sign(direction);
    float2 f = fract(p);
    return mix(getFromColor(f, fromTexture, ratio, _fromR),
               getToColor(f, toTexture, ratio, _toR),
               step(0.0, p.y) * step(p.y, 1.0) * step(0.0, p.x) * step(p.x, 1.0)
               );
}

