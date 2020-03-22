// Author: nwoeanhinnogaehr
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 KaleidoScopeFragment(VertexOut vertexIn [[ stage_in ]],
                                     texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                     texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                     constant float & angle [[ buffer(0) ]],
                                     constant float & speed [[ buffer(1) ]],
                                     constant float & power [[ buffer(2) ]],
                                     constant float & ratio [[ buffer(3) ]],
                                     constant float & progress [[ buffer(4) ]],
                                     sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float2 p = uv.xy / float2(1.0).xy;
    float2 q = p;
    float t = pow(progress, power)*speed;
    p = p -0.5;
    for (int i = 0; i < 7; i++) {
        p = float2(sin(t)*p.x + cos(t)*p.y, sin(t)*p.y - cos(t)*p.x);
        t += angle;
        p = abs(fmod(p, 2.0) - 1.0);
    }
    abs(fmod(p, 1.0));
    return mix(mix(getFromColor(q, fromTexture, ratio, _fromR),
                   getToColor(q, toTexture, ratio, _toR), progress),
               mix(getFromColor(p, fromTexture, ratio, _fromR),
                   getToColor(p, toTexture, ratio, _toR), progress),
               1.0 - 2.0*abs(progress - 0.5));
}
