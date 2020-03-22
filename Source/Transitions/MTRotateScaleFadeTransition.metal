// Author: Fernando Kuteken
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 RotateScaleFadeFragment(VertexOut vertexIn [[ stage_in ]],
                                        texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                        constant float & scale [[ buffer(0) ]],
                                        constant float & rotations [[ buffer(1) ]],
                                        constant float2 & center [[ buffer(2) ]],
                                        constant float4 & backColor [[ buffer(3) ]],
                                        constant float & ratio [[ buffer(4) ]],
                                        constant float & progress [[ buffer(5) ]],
                                        sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float2 difference = uv - center;
    float2 dir = normalize(difference);
    float dist = length(difference);
    
    float angle = 2.0 * PI * rotations * progress;
    
    float c = cos(angle);
    float s = sin(angle);
    
    float currentScale = mix(scale, 1.0, 2.0 * abs(progress - 0.5));
    
    float2 rotatedDir = float2(dir.x  * c - dir.y * s, dir.x * s + dir.y * c);
    float2 rotatedUv = center + rotatedDir * dist / currentScale;
    
    if (rotatedUv.x < 0.0 || rotatedUv.x > 1.0 ||
        rotatedUv.y < 0.0 || rotatedUv.y > 1.0)
        return backColor;
    
    return mix(getFromColor(rotatedUv, fromTexture, ratio, _fromR),
               getToColor(rotatedUv, toTexture, ratio, _toR),
               progress);
}

