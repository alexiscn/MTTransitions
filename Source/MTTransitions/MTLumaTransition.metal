// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 LumaFragment(VertexOut vertexIn [[ stage_in ]],
                             texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                             texture2d<float, access::sample> toTexture [[ texture(1) ]],
                             texture2d<float, access::sample> luma [[ texture(2) ]],
                             constant float & ratio [[ buffer(0) ]],
                             constant float & progress [[ buffer(1) ]],
                             sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());

    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float r = luma.sample(s, uv).r;
    
    return mix(getFromColor(uv, toTexture, ratio, _toR),
               getToColor(uv, fromTexture, ratio, _fromR),
               step(progress, r)
               );
}
