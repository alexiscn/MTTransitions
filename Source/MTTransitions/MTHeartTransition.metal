// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float inHeart(float2 p, float2 center, float size) {
    if (size == 0.0) {
        return 0.0;
    }
    float2 o = (p-center)/(1.6*size);
    float a = o.x*o.x+o.y*o.y-0.3;
    return step(a*a*a, o.x*o.x*o.y*o.y*o.y);
}

fragment float4 HeartFragment(VertexOut vertexIn [[ stage_in ]],
                              texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                              texture2d<float, access::sample> toTexture [[ texture(1) ]],
                              constant float & ratio [[ buffer(0) ]],
                              constant float & progress [[ buffer(1) ]],
                              sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    return mix(getFromColor(uv, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               inHeart(uv, float2(0.5, 0.4), progress)
               );
}

