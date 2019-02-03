// Author: Fernando Kuteken
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float4 blend(float4 a, float4 b) {
    return a * b;
}

fragment float4 MultiplyBlendFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    
    float4 blended = blend(getFromColor(uv, fromTexture, ratio, _fromR), getFromColor(uv, toTexture, ratio, _toR));
    
    if (progress < 0.5) {
        return mix(getFromColor(uv, fromTexture, ratio, _fromR), blended, 2.0 * progress);
    } else {
        return mix(blended, getFromColor(uv, toTexture, ratio, _toR), 2.0 * progress - 1.0);
    }
}
