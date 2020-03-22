// Author: paniq
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 MorphFragment(VertexOut vertexIn [[ stage_in ]],
                              texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                              texture2d<float, access::sample> toTexture [[ texture(1) ]],
                              constant float & strength [[ buffer(0) ]],
                              constant float & ratio [[ buffer(1) ]],
                              constant float & progress [[ buffer(2) ]],
                              sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 ca = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 cb = getToColor(uv, toTexture, ratio, _toR);
    float2 oa = (((ca.rg + ca.b) * 0.5) * 2.0 - 1.0);
    float2 ob = (((cb.rg + cb.b) * 0.5) * 2.0 - 1.0);
    float2 oc = mix(oa, ob, 0.5) * strength;
    
    float w0 = progress;
    float w1 = 1.0 - w0;
    return mix(getFromColor(uv + oc * w0, fromTexture, ratio, _fromR),
               getToColor(uv - oc * w1, toTexture, ratio, _toR),
               progress);
}
