// License: MIT
// Author: fkuteken
// ported by gre from https://gist.github.com/fkuteken/f63e3009c1143950dee9063c3b83fb88

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 CircleCropFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & bgcolor [[ buffer(0) ]],
                                   constant float & ratio [[ buffer(1) ]],
                                   constant float & progress [[ buffer(2) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
 
    float2 ratio2 = float2(1.0, 1.0 / ratio);
    float s = pow(2.0 * abs(progress - 0.5), 3.0);
    float dist = length((float2(uv) - 0.5) * ratio2);
    
    float4 from = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 to = getToColor(uv, toTexture, ratio, _toR);
    
    return mix(
               progress < 0.5 ?  from: to, // branching is ok here as we statically depend on progress uniform (branching won't change over pixels)
               bgcolor,
               step(s, dist)
    );
}
