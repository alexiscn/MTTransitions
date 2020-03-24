// author: Brandon Anzaldi
// license: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

// Pseudo-random noise function
// http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
float noise(float2 co, float progress)
{
    float a = 12.9898;
    float b = 78.233;
    float c = 43758.5453;
    float dt= dot(co.xy * progress, float2(a, b));
    float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

fragment float4 TVStaticFragment(VertexOut vertexIn [[ stage_in ]],
                                 texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                 texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                 constant float & offset [[ buffer(0) ]],
                                 constant float & ratio [[ buffer(1) ]],
                                 constant float & progress [[ buffer(2) ]],
                                 sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    if (progress < offset) {
        return getFromColor(uv, fromTexture, ratio, _fromR);
    } else if (progress > (1.0 - offset)) {
        return getToColor(uv, toTexture, ratio, _toR);
    } else {
        return float4(float3(noise(uv, progress)), 1.0);
    }
}
