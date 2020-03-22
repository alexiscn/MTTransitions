// Author: Fernando Kuteken
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 PolarFunctionFragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                      texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                      constant int & segments [[ buffer(0) ]],
                                      constant float & ratio [[ buffer(1) ]],
                                      constant float & progress [[ buffer(2) ]],
                                      sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float angle = atan2(uv.y - 0.5, uv.x - 0.5) - 0.5 * PI;
    //  float normalized = (angle + 1.5 * PI) * (2.0 * PI);
    
    float radius = (cos(float(segments) * angle) + 4.0) / 4.0;
    float difference = length(uv - float2(0.5, 0.5));
    
    if (difference > radius * progress) {
        return getFromColor(uv, fromTexture, ratio, _fromR);
    } else {
        return getFromColor(uv, toTexture, ratio, _toR);
    }
}

