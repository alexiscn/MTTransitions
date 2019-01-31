// Author: Fernando Kuteken
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 AngularFragment(VertexOut vertexIn [[ stage_in ]],
                                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                constant float & startingAngle [[ buffer(0) ]],
                                constant float & ratio [[ buffer(1) ]],
                                constant float & progress [[ buffer(2) ]],
                                sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    float _fromR = fromTexture.get_width()/fromTexture.get_height();
    float _toR = toTexture.get_width()/toTexture.get_height();
    
    float offset = startingAngle * PI / 180.0;
    float angle = atan2(uv.y - 0.5, uv.x - 0.5) + offset;
    float normalizedAngle = (angle + PI) / (2.0 * PI);
    normalizedAngle = normalizedAngle - floor(normalizedAngle);
    return mix(
               getFromColor(uv, fromTexture, ratio, _fromR),
               getFromColor(uv, toTexture, ratio, _toR),
               step(normalizedAngle, progress));
}

