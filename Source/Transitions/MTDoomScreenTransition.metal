// Author: Zeh Fernando
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float doomscreen_rand(int num) {
    return fract(mod(float(num) * 67123.313, 12.0) * sin(float(num) * 10.3) * cos(float(num)));
}

float doomscreen_wave(int num, int bars, float frequency) {
    float fn = float(num) * frequency * 0.1 * float(bars);
    return cos(fn * 0.5) * cos(fn * 0.13) * sin((fn+10.0) * 0.3) / 2.0 + 0.5;
}

float doomscreen_drip(int num, int bars, float dripScale) {
    return sin(float(num) / float(bars - 1) * 3.141592) * dripScale;
}

float doomscreen_pos(int num, int bars, float frequency, float dripScale, float noise) {
    return (noise == 0.0 ? doomscreen_wave(num, bars, frequency) : mix(doomscreen_wave(num, bars, frequency), doomscreen_rand(num), noise)) + (dripScale == 0.0 ? 0.0 : doomscreen_drip(num, bars, dripScale));
}

fragment float4 DoomScreenFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & dripScale [[ buffer(0) ]],
                                   constant int & bars [[ buffer(1) ]],
                                   constant float & noise [[ buffer(2) ]],
                                   constant float & frequency [[ buffer(3) ]],
                                   constant float & amplitude [[ buffer(4) ]],
                                   constant float & ratio [[ buffer(5) ]],
                                   constant float & progress [[ buffer(6) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    int bar = int(uv.x * (float(bars)));
    float scale = 1.0 + doomscreen_pos(bar, bars, frequency, dripScale, noise) * amplitude;
    float phase = progress * scale;
    float posY = uv.y / float2(1.0).y;
    float2 p;
    float4 c;
    if (phase + posY < 1.0) {
        p = float2(uv.x, uv.y + mix(0.0, float2(1.0).y, phase)) / float2(1.0).xy;
        c = getFromColor(p, fromTexture, ratio, _fromR);
    } else {
        p = uv.xy / float2(1.0).xy;
        c = getToColor(p, toTexture, ratio, _toR);
    }
    
    // Finally, apply the color
    return c;
}
