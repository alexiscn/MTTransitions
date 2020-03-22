// License: MIT
// Author: P-Seebauer
// ported by gre from https://gist.github.com/P-Seebauer/2a5fa2f77c883dd661f9

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 ColourDistanceFragment(VertexOut vertexIn [[ stage_in ]],
                                       texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                       texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                       constant float & power [[ buffer(0) ]],
                                       constant float & ratio [[ buffer(1) ]],
                                       constant float & progress [[ buffer(2) ]],
                                       sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 fTex = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 tTex = getToColor(uv, toTexture, ratio, _toR);
    float m = step(distance(fTex, tTex), progress);
    return mix(mix(fTex, tTex, m),
               tTex,
               pow(progress, power)
               );
}
