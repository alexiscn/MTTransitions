// Author: Ben Zhang
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 OverexposureFragment(VertexOut vertexIn [[ stage_in ]],
                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                texture2d<float, access::sample> toTexture [[ texture(1) ]],
                constant float & strength [[ buffer(0) ]],
                constant float & ratio [[ buffer(1) ]],
                constant float & progress [[ buffer(2) ]],
                sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 from = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 to = getToColor(uv, toTexture, ratio, _toR);
    // Multipliers
    float from_m = 1.0 - progress + sin(PI * progress) * strength;
    float to_m = progress + sin(PI * progress) * strength;

      return float4(
        from.r * from.a * from_m + to.r * to.a * to_m,
        from.g * from.a * from_m + to.g * to.a * to_m,
        from.b * from.a * from_m + to.b * to.a * to_m,
        mix(from.a, to.a, progress)
      );
}
