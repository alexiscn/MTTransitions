// Author: hjm1fb
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;


float2 hash(float2 p)  // replace this by something better
{
    p = float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(float2 p) {
    const float K1 = 0.366025404;  // (sqrt(3)-1)/2;
    const float K2 = 0.211324865;  // (3-sqrt(3))/6;
    
    float2 i = floor(p + (p.x + p.y) * K1);
    float2 a = p - i + (i.x + i.y) * K2;
    float m = step(a.y, a.x);
    float2 o = float2(m, 1.0 - m);
    float2 b = a - o + K2;
    float2 c = a - 1.0 + 2.0 * K2;
    float3 h = max(0.5 - float3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    float3 n = h * h * h * h * float3(dot(a, hash(i + 0.0)), dot(b, hash(i + o)), dot(c, hash(i + 1.0)));
    return dot(n, float3(70.0));
}

fragment float4 DissolveFragment(VertexOut vertexIn [[ stage_in ]],
                                 texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                 texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                 constant float & uLineWidth [[ buffer(0) ]],
                                 constant float3 & uSpreadClr [[ buffer(1) ]],
                                 constant float3 & uHotClr [[ buffer(2) ]],
                                 constant float & uPow [[ buffer(3) ]],
                                 constant float & uIntensity [[ buffer(4) ]],
                                 constant float & ratio [[ buffer(5) ]],
                                 constant float & progress [[ buffer(6) ]],
                                 sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 from = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 to = getToColor(uv, toTexture, ratio, _toR);
    float4 outColor;
    float burn;
    burn = 0.5 + 0.5 * (0.299 * from.r + 0.587 * from.g + 0.114 * from.b);
    
    float show = burn - progress;
    if (show < 0.001) {
        outColor = to;
    } else {
        float factor = 1.0 - smoothstep(0.0, uLineWidth, show);
        float3 burnColor = mix(uSpreadClr, uHotClr, factor);
        burnColor = pow(burnColor, float3(uPow)) * uIntensity;
        float3 finalRGB = mix(from.rgb, burnColor, factor * step(0.0001, progress));
        outColor = float4(finalRGB * from.a, from.a);
    }
    return outColor;
}
