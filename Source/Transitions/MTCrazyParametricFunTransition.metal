// Author: mandubian
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 CrazyParametricFunFragment(VertexOut vertexIn [[ stage_in ]],
                                           texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                           texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                           constant float & a [[ buffer(0) ]],
                                           constant float & b [[ buffer(1) ]],
                                           constant float & smoothness [[ buffer(2) ]],
                                           constant float & amplitude [[ buffer(3) ]],
                                           constant float & ratio [[ buffer(4) ]],
                                           constant float & progress [[ buffer(5) ]],
                                           sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 p = uv.xy / float2(1.0).xy;
    float2 dir = p - float2(.5);
    float dist = length(dir);
    float x = (a - b) * cos(progress) + b * cos(progress * ((a / b) - 1.0));
    float y = (a - b) * sin(progress) - b * sin(progress * ((a / b) - 1.0));
    float2 offset = dir * float2(sin(progress  * dist * amplitude * x), sin(progress * dist * amplitude * y)) / smoothness;
    return mix(getFromColor(p + offset, fromTexture, ratio, _fromR),
               getToColor(p, toTexture, ratio, _toR),
               smoothstep(0.2, 1.0, progress)
               );
}
