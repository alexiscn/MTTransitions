// Author: Gunnar Roth
// Based on work from natewave
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 GlitchMemoriesFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    float2 block = floor(uv.xy / float2(16));
    float2 uv_noise = block / float2(64);
    uv_noise += floor(float2(progress) * float2(1200.0, 3500.0)) / float2(64);
    float2 dist = progress > 0.0 ? (fract(uv_noise) - 0.5) * 0.3 *(1.0 -progress) : float2(0.0);
    float2 red = uv + dist * 0.2;
    float2 green = uv + dist * 0.3;
    float2 blue = uv + dist * 0.5;
    
    float r = mix(getFromColor(red, fromTexture, ratio, _fromR),
                  getToColor(red, toTexture, ratio, _toR),
                  progress).r;
    float g = mix(getFromColor(green, fromTexture, ratio, _fromR),
                  getToColor(green, toTexture, ratio, _toR),
                  progress).g;
    float b = mix(getFromColor(blue, fromTexture, ratio, _fromR),
                  getToColor(blue, toTexture, ratio, _toR),
                  progress).b;
    return float4(r, g, b, 1.0);
}
