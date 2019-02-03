// Author: Fernando Kuteken
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 CircleFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant float2 & center [[ buffer(0) ]],
                               constant float3 & backColor [[ buffer(1) ]],
                               constant float & ratio [[ buffer(2) ]],
                               constant float & progress [[ buffer(3) ]],
                               sampler textureSampler [[ sampler(0) ]]) 
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float distance = length(uv - center);
    float radius = sqrt(8.0) * abs(progress - 0.5);
    if (distance > radius) {
        return float4(backColor, 1.0);
    } else {
        if (progress < 0.5) {
            return getFromColor(uv, fromTexture, ratio, _fromR);
        } else {
            return getToColor(uv, toTexture, ratio, _toR);
        }
    }
}

