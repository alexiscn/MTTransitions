// Author: mikolalysenko
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 offset(float progress, float x, float theta) {
    //float phase = progress * progress + progress + theta;
    float shifty = 0.03 * progress * cos(10.0*(progress + x));
    return float2(0, shifty);
}

fragment float4 DreamyFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    return mix(getFromColor(uv + offset(progress, uv.x, 0.0), fromTexture, ratio, _fromR),
               getToColor(uv + offset(1.0-progress, uv.x, 3.14), toTexture, ratio, _toR),
               progress);
}
