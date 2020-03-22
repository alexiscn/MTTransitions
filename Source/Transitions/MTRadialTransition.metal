// License: MIT
// Author: Xaychru
// ported by gre from https://gist.github.com/Xaychru/ce1d48f0ce00bb379750

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 RadialFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant float & smoothness [[ buffer(0) ]],
                               constant float & ratio [[ buffer(1) ]],
                               constant float & progress [[ buffer(2) ]],
                               sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 rp = uv * 2.0 - 1.0;
    return mix(getToColor(uv, toTexture, ratio, _toR),
               getFromColor(uv, fromTexture, ratio, _fromR),
               smoothstep(0.0, smoothness, atan2(rp.y,rp.x) - (progress - 0.5) * PI * 2.5)
               );
}

