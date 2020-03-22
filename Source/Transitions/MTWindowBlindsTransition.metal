// Author: Fabien Benetou
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 WindowBlindsFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    float t = progress;
  
    if (mod(floor(uv.y * 100.0 * progress),2.0) == 0.0) {
        t *= 2.0 - 0.5;
    }
    
    return mix(
               getFromColor(uv, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               mix(t, progress, smoothstep(0.8, 1.0, progress))
               );
}
