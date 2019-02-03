// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 FadeColorFragment(VertexOut vertexIn [[ stage_in ]],
                                  texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                  texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                  constant float3 & color [[ buffer(0) ]],
                                  constant float & colorPhase [[ buffer(1) ]],
                                  constant float & ratio [[ buffer(2) ]],
                                  constant float & progress [[ buffer(3) ]],
                                  sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    return mix(mix(float4(color, 1.0),
                   getFromColor(uv, fromTexture, ratio, _fromR),
                   smoothstep(1.0-colorPhase, 0.0, progress)),
               mix(float4(color, 1.0),
                   getToColor(uv, toTexture, ratio, _toR),
                   smoothstep(colorPhase, 1.0, progress)),
               progress);
}
