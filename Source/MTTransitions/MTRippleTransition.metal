// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 RippleFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant float & speed [[ buffer(0) ]],
                               constant float & amplitude [[ buffer(1) ]],
                               constant float & ratio [[ buffer(2) ]],
                               constant float & progress [[ buffer(3) ]],
                               sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 dir = uv - float2(.5);
    float dist = length(dir);
    float2 offset = dir * (sin(progress * dist * amplitude - progress * speed) + .5) / 30.;
    return mix(getFromColor(uv + offset, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               smoothstep(0.2, 1.0, progress)
               );
}

