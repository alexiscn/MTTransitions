// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;
// author: gre

fragment float4 BurnFragment(VertexOut vertexIn [[ stage_in ]],
                             texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                             texture2d<float, access::sample> toTexture [[ texture(1) ]],
                             constant float3 & color [[ buffer(0) ]],
                             constant float & ratio [[ buffer(1) ]],
                             constant float & progress [[ buffer(2) ]],
                             sampler textureSampler [[ sampler(0) ]]) 
{
    float2 uv = vertexIn.textureCoordinate;
    float _fromR = fromTexture.get_width()/fromTexture.get_height();
    float _toR = toTexture.get_width()/toTexture.get_height();
    
    return mix(
               getFromColor(uv, fromTexture, ratio, _fromR) + float4(progress*color, 1.0),
               getFromColor(uv, toTexture, ratio, _toR) + float4((1.0-progress)*color, 1.0),
               progress
               );
}

