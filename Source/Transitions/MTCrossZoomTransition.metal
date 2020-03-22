// License: MIT
// Author: rectalogic
// ported by gre from https://gist.github.com/rectalogic/b86b90161503a0023231

// Converted from https://github.com/rectalogic/rendermix-basic-effects/blob/master/assets/com/rendermix/CrossZoom/CrossZoom.frag
// Which is based on https://github.com/evanw/glfx.js/blob/master/src/filters/blur/zoomblur.js
// With additional easing functions from https://github.com/rectalogic/rendermix-basic-effects/blob/master/assets/com/rendermix/Easing/Easing.glsllib

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float Linear_ease(float begin, float change, float duration, float time) {
    return change * time / duration + begin;
}

float Exponential_easeInOut(float begin, float change, float duration, float time) {
    if (time == 0.0)
        return begin;
    else if (time == duration)
        return begin + change;
    time = time / (duration / 2.0);
    if (time < 1.0)
        return change / 2.0 * pow(2.0, 10.0 * (time - 1.0)) + begin;
    return change / 2.0 * (-pow(2.0, -10.0 * (time - 1.0)) + 2.0) + begin;
}

float Sinusoidal_easeInOut(float begin, float change, float duration, float time) {
    return -change / 2.0 * (cos(PI * time / duration) - 1.0) + begin;
}


float3 crossFade(float2 uv, float dissolve, float ratio, texture2d<float, access::sample> fromTexture, float _fromR,
                 texture2d<float, access::sample> toTexture, float _toR) {
    return mix(getFromColor(uv, fromTexture, ratio, _fromR).rgb,
               getFromColor(uv, toTexture, ratio, _toR).rgb,
               dissolve);
}

fragment float4 CrossZoomFragment(VertexOut vertexIn [[ stage_in ]],
                                  texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                  texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                  constant float & strength [[ buffer(0) ]],
                                  constant float & ratio [[ buffer(1) ]],
                                  constant float & progress [[ buffer(2) ]],
                                  sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 texCoord = uv.xy / float2(1.0).xy;
    
    // Linear interpolate center across center half of the image
    float2 center = float2(Linear_ease(0.25, 0.5, 1.0, progress), 0.5);
    float dissolve = Exponential_easeInOut(0.0, 1.0, 1.0, progress);
    
    // Mirrored sinusoidal loop. 0->strength then strength->0
    float st = Sinusoidal_easeInOut(0.0, strength, 0.5, progress);
    
    float3 color = float3(0.0);
    float total = 0.0;
    float2 toCenter = center - texCoord;
    
    /* randomize the lookup values to hide the fixed number of samples */
    float offset = rand(uv);
    
    for (float t = 0.0; t <= 40.0; t++) {
        float percent = (t + offset) / 40.0;
        float weight = 4.0 * (percent - percent * percent);
        color += crossFade(texCoord + toCenter * percent * st, dissolve, ratio, fromTexture, _fromR, toTexture, _toR) * weight;
        total += weight;
    }
    return float4(color / total, 1.0);
}
