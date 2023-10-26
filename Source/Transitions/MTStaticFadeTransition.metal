// Author: Ben Lucas
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float rnd (float2 st) {
    return fract(sin(dot(st.xy,
                         float2(10.5302340293,70.23492931)))*
                 12345.5453123);
}

float4 staticNoise (float2 st, float offset, float luminosity) {
    float staticR = luminosity * rnd(st * float2(offset * 2.0, offset * 3.0));
    float staticG = luminosity * rnd(st * float2(offset * 3.0, offset * 5.0));
    float staticB = luminosity * rnd(st * float2(offset * 5.0, offset * 7.0));
    return float4(staticR, staticG, staticB, 1.0);
}

float staticIntensity(float t)
{
    float transitionProgress = abs(2.0*(t-0.5));
    float transformedThreshold =1.2*(1.0 - transitionProgress)-0.1;
    return min(1.0, transformedThreshold);
}

fragment float4 StaticFadeFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & nNoisePixels [[ buffer(0) ]],
                                   constant float & staticLuminosity [[ buffer(1) ]],
                                   constant float & ratio [[ buffer(2) ]],
                                   constant float & progress [[ buffer(3) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float baseMix = step(0.5, progress);
    float4 transitionMix = mix(
                               getFromColor(uv, fromTexture, ratio, _fromR),
                               getToColor(uv, toTexture, ratio, _toR),
                               baseMix
                               );
    
    float2 uvStatic = floor(uv * nNoisePixels)/nNoisePixels;
    
    float4 staticColor = staticNoise(uvStatic, progress, staticLuminosity);
    
    float staticThresh = staticIntensity(progress);
    float staticMix = step(rnd(uvStatic), staticThresh);
    
    return mix(transitionMix, staticColor, staticMix);
    
}
