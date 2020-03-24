// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 SquaresWireFragment(VertexOut vertexIn [[ stage_in ]],
                                    texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                    texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                    constant float2 & direction [[ buffer(0) ]],
                                    constant int2 & squares [[ buffer(1) ]],
                                    constant float & smoothness [[ buffer(2) ]],
                                    constant float & ratio [[ buffer(3) ]],
                                    constant float & progress [[ buffer(4) ]],
                                    sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    const float2 center = float2(0.5, 0.5);
    
    float2 v = normalize(direction);
    v = v / (abs(v.x) + abs(v.y));
    float d = v.x * center.x + v.y * center.y;
    float offset = smoothness;
    float pr = smoothstep(-offset, 0.0, v.x * uv.x + v.y * uv.y - (d - 0.5 + progress * (1.0 + offset)));
    float2 squarep = fract(uv * float2(squares));
    float2 squaremin = float2(pr/2.0);
    float2 squaremax = float2(1.0 - pr/2.0);
    float a = (1.0 - step(progress, 0.0))
                * step(squaremin.x, squarep.x)
                * step(squaremin.y, squarep.y)
                * step(squarep.x, squaremax.x)
                * step(squarep.y, squaremax.y);
    
    return mix(getFromColor(uv, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               a);
}

