// Author: YueDev
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 getMosaicUV(float2 uv, float mosaicNum, float progress) {
    float mosaicWidth = 2.0 / mosaicNum * min(progress, 1.0 - progress);
    float mX = floor(uv.x / mosaicWidth) + 0.5;
    float mY = floor(uv.y / mosaicWidth) + 0.5;
    return float2(mX * mosaicWidth, mY * mosaicWidth);
}

fragment float4 MosaicYueDevFragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                      texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                     constant float & mosaicNum [[ buffer(0) ]],
                                      constant float & ratio [[ buffer(1) ]],
                                      constant float & progress [[ buffer(2) ]],
                                      sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 mosaicUV = min(progress, 1.0 - progress) == 0.0 ? uv : getMosaicUV(uv, mosaicNum, progress);
    
    return mix(
               getFromColor(mosaicUV, fromTexture, ratio, _fromR),
               getToColor(mosaicUV, toTexture, ratio, _toR),
               progress * progress);
}
