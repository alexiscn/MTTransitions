// Author: Eke Péter <peterekepeter@gmail.com>
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 CrossWarpFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    float x = progress;
    x = smoothstep(.0,1.0,(x * 2.0 + uv.x - 1.0));
    return mix(getFromColor((uv - 0.5) * (1.0 - x) + 0.5, fromTexture, ratio, _fromR),
               getToColor((uv - 0.5) * x + 0.5, toTexture, ratio, _toR),
               x);
}
