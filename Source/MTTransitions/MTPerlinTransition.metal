// Author: Rich Harris
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

//#ifdef GL_ES
//precision mediump float;
//#endif



// http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
//float random(float2 co)
//{
//    highp float a = seed;
//    highp float b = 78.233;
//    highp float c = 43758.5453;
//    highp float dt= dot(co.xy ,float2(a,b));
//    highp float sn= mod(dt,3.14);
//    return fract(sin(sn) * c);
//}
//
//// 2D Noise based on Morgan McGuire @morgan3d
//// https://www.shadertoy.com/view/4dS3Wd
//float noise (in float2 st) {
//    float2 i = floor(st);
//    float2 f = fract(st);
//
//    // Four corners in 2D of a tile
//    float a = random(i);
//    float b = random(i + float2(1.0, 0.0));
//    float c = random(i + float2(0.0, 1.0));
//    float d = random(i + float2(1.0, 1.0));
//
//    // Smooth Interpolation
//
//    // Cubic Hermine Curve.  Same as SmoothStep()
//    float2 u = f*f*(3.0-2.0*f);
//    // u = smoothstep(0.,1.,f);
//
//    // Mix 4 coorners porcentages
//    return mix(a, b, u.x) +
//            (c - a)* u.y * (1.0 - u.x) +
//            (d - b) * u.x * u.y;
//}
//
//
//fragment float4 PerlinFragment(VertexOut vertexIn [[ stage_in ]],
//                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
//                texture2d<float, access::sample> toTexture [[ texture(1) ]],
//                constant float & scale [[ buffer(0) ]],
//                constant float & seed [[ buffer(1) ]],
//                constant float & smoothness [[ buffer(2) ]],
//                constant float & ratio [[ buffer(3) ]],
//                constant float & progress [[ buffer(4) ]],
//                sampler textureSampler [[ sampler(0) ]])
//{
//    float2 uv = vertexIn.textureCoordinate;
//    float _fromR = fromTexture.get_width()/fromTexture.get_height();
//    float _toR = toTexture.get_width()/toTexture.get_height();
//
//  float4 from = getFromColor(uv, fromTexture, ratio, _fromR);
//  float4 to = getFromColor(uv, toTexture, ratio, _toR);
//  float n = noise(uv * scale);
//
//  float p = mix(-smoothness, 1.0 + smoothness, progress);
//  float lower = p - smoothness;
//  float higher = p + smoothness;
//
//  float q = smoothstep(lower, higher, n);
//
//  return mix(
//    from,
//    to,
//    1.0 - q
//  );
//}

