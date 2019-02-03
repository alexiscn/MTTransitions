// Author: mandubian
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float compute(float2 p, float progress, float2 center, float amplitude, float waves) {
    float2 o = p * sin(progress * amplitude) - center;
    // horizontal vector
    float2 h = float2(1.0, 0.0);
    // butterfly polar function (don't ask me why this one :))
    float theta = acos(dot(o, h)) * waves;
    return (exp(cos(theta)) - 2.0 * cos(4.0 * theta) + pow(sin((2.0 * theta - PI) / 24.), 5.0)) / 10.0;
}

fragment float4 ButterflyWaveScrawlerFragment(VertexOut vertexIn [[ stage_in ]],
                                              texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                              texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                              constant float & colorSeparation [[ buffer(0) ]],
                                              constant float & amplitude [[ buffer(1) ]],
                                              constant float & waves [[ buffer(2) ]],
                                              constant float & ratio [[ buffer(3) ]],
                                              constant float & progress [[ buffer(4) ]],
                                              sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 p = uv.xy / float2(1.0).xy;
    float inv = 1.0 - progress;
//    float2 dir = p - float2(.5);
//    float dist = length(dir);
    float disp = compute(p, progress, float2(0.5, 0.5), amplitude, waves);
    float4 texTo = getToColor(p + inv*disp, toTexture, ratio, _toR);
    float4 texFrom = float4(
                            getFromColor(p + progress*disp*(1.0 - colorSeparation), fromTexture, ratio, _fromR).r,
                            getFromColor(p + progress*disp, fromTexture, ratio, _fromR).g,
                            getFromColor(p + progress*disp*(1.0 + colorSeparation), fromTexture, ratio, _fromR).b,
                            1.0);
    return texTo * progress + texFrom * inv;
}
