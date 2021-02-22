// Author:towrabbit
// License: MIT


#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float random (float2 st) {
    return fract(sin(dot(st.xy,float2(12.9898,78.233)))*43758.5453123);
}

fragment float4 MTRandomNoisexFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    float4 leftSide = getFromColor(uv, fromTexture, ratio, _fromR);
    float2 uv1 = uv;
//    float2 uv2 = uv;
    float uvz = floor(random(uv1)+progress);
    float4 rightSide = getToColor(uv, toTexture, ratio, _toR);
//    float p = progress*2.0;
    return mix(leftSide,rightSide,uvz);
//    return leftSide * ceil(uv.x*2.-p) + rightSide * ceil(-uv.x*2.+p);
}
