// License: MIT
// Author: pthrasher
// adapted by gre from https://gist.github.com/pthrasher/04fd9a7de4012cbb03f6

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 CrossHatchFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & threshold [[ buffer(0) ]],
                                   constant float2 & center [[ buffer(1) ]],
                                   constant float & fadeEdge [[ buffer(2) ]],
                                   constant float & ratio [[ buffer(3) ]],
                                   constant float & progress [[ buffer(4) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float dist = distance(center, uv) / threshold;
    float r = progress - min(rand(float2(uv.y, 0.0)), rand(float2(0.0, uv.x)));
    return mix(getFromColor(uv, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               mix(0.0,
                   mix(step(dist, r),1.0, smoothstep(1.0-fadeEdge, 1.0, progress)),
                   smoothstep(0.0, fadeEdge, progress))
               );
}
