// Author: hong
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 skewRight(float2 p, float progress) {
  float skewX = (p.x - progress)/(0.5 - progress) * 0.5;
  float skewY =  (p.y - 0.5)/(0.5 + progress * (p.x - 0.5) / 0.5)* 0.5  + 0.5;
  return float2(skewX, skewY);
}

float2 skewLeft(float2 p, float progress) {
  float skewX = (p.x - 0.5)/(progress - 0.5) * 0.5 + 0.5;
  float skewY = (p.y - 0.5) / (0.5 + (1.0 - progress ) * (0.5 - p.x) / 0.5) * 0.5  + 0.5;
  return float2(skewX, skewY);
}

float4 addShade(float progress) {
  float shadeVal  =  max(0.7, abs(progress - 0.5) * 2.0);
  return float4(float3(shadeVal ), 1.0);
}


fragment float4 BookFlipFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    float pr = step(1.0 - progress, uv.x);

    if (uv.x < 0.5) {
        return mix(getFromColor(uv, fromTexture, ratio, _fromR),
                   getToColor(skewLeft(uv, progress), toTexture, ratio, _toR) * addShade(progress),
                   pr);
    } else {
        return mix(getFromColor(skewRight(uv, progress), fromTexture, ratio, _fromR) * addShade(progress),
                   getToColor(uv, toTexture, ratio, _toR),
                   pr);
    }
}
