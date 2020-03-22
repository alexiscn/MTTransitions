// Author: @Flexi23
// License: MIT
// inspired by http://www.wolframalpha.com/input/?i=cannabis+curve

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 CannabisleafFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    if(progress == 0.0){
        return getFromColor(uv, fromTexture, ratio, _fromR);
    }
    float2 leaf_uv = (uv - float2(0.5))/10./pow(progress,3.5);
    leaf_uv.y += 0.35;
    float r = 0.18;
    float o = atan2(leaf_uv.y, leaf_uv.x);
    
    float4 a = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 b = getToColor(uv, toTexture, ratio, _toR);
    float4 c = 1.0 - step(1.0 - length(leaf_uv) + r*(1.0 + sin(o))*(1.0 + 0.9 * cos(8.0*o))*(1.0 + 0.1*cos(24.0*o))*(0.9+0.05*cos(200.0*o)), 1.0);
    return mix(a, b, c);
}

