// Author: Rich Harris
// License: MIT
// http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float perlin_random(float2 co, float seed) {
    float a = seed;
    float b = 78.233;
    float c = 43758.5453;
    float dt= dot(co.xy ,float2(a,b));
    float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float perlin_noise(float2 st, float seed) {
    float2 i = floor(st);
    float2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = perlin_random(i, seed);
    float b = perlin_random(i + float2(1.0, 0.0), seed);
    float c = perlin_random(i + float2(0.0, 1.0), seed);
    float d = perlin_random(i + float2(1.0, 1.0), seed);
    
    // Smooth Interpolation
    
    // Cubic Hermine Curve.  Same as SmoothStep()
    float2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);
    
    // Mix 4 coorners porcentages
    return mix(a, b, u.x) +
    (c - a)* u.y * (1.0 - u.x) +
    (d - b) * u.x * u.y;
}


fragment float4 PerlinFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant float & scale [[ buffer(0) ]],
                               constant float & seed [[ buffer(1) ]],
                               constant float & smoothness [[ buffer(2) ]],
                               constant float & ratio [[ buffer(3) ]],
                               constant float & progress [[ buffer(4) ]],
                               sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 from = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 to = getToColor(uv, toTexture, ratio, _toR);
    float n = perlin_noise(uv * scale, seed);
    
    float p = mix(-smoothness, 1.0 + smoothness, progress);
    float lower = p - smoothness;
    float higher = p + smoothness;
    
    float q = smoothstep(lower, higher, n);
    
    return mix(from, to, 1.0 - q);
}

