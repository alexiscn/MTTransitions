// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float3 grayscale (float3 color) {
    return float3(0.2126*color.r + 0.7152*color.g + 0.0722*color.b);
}

fragment float4 FadegrayscaleFragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                      texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                      constant float & intensity [[ buffer(0) ]],
                                      constant float & ratio [[ buffer(1) ]],
                                      constant float & progress [[ buffer(2) ]],
                                      sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    float4 fc = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 tc = getFromColor(uv, toTexture, ratio, _toR);
    return mix(mix(float4(grayscale(fc.rgb), 1.0), fc, smoothstep(1.0-intensity, 0.0, progress)),
               mix(float4(grayscale(tc.rgb), 1.0), tc, smoothstep(    intensity, 1.0, progress)),
               progress);
}

