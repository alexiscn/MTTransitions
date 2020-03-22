// Author: Mr Speaker
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 PinwheelFragment(VertexOut vertexIn [[ stage_in ]],
                                 texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                 texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                 constant float & speed [[ buffer(0) ]],
                                 constant float & ratio [[ buffer(1) ]],
                                 constant float & progress [[ buffer(2) ]],
                                 sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 p = uv.xy / float2(1.0).xy;
    
    float circPos = atan2(p.y - 0.5, p.x - 0.5) + progress * speed;
    float modPos = mod(circPos, 3.1415 / 4.);
    float s = sign(progress - modPos);
    
    return mix(getToColor(p, toTexture, ratio, _toR),
               getFromColor(p, fromTexture, ratio, _fromR),
               step(s, 0.5));
}
