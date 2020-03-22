// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;
 
fragment float4 SqueezeFragment(VertexOut vertexIn [[ stage_in ]],
                                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                constant float & colorSeparation [[ buffer(0) ]],
                                constant float & ratio [[ buffer(1) ]],
                                constant float & progress [[ buffer(2) ]],
                                sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float y = 0.5 + (uv.y-0.5) / (1.0-progress);
    if (y < 0.0 || y > 1.0) {
        return getToColor(uv, toTexture, ratio, _toR);
    } else {
        float2 fp = float2(uv.x, y);
        float2 off = progress * float2(0.0, colorSeparation);
        float4 c = getFromColor(fp, fromTexture, ratio, _fromR);
        float4 cn = getFromColor(fp - off, fromTexture, ratio, _fromR);
        float4 cp = getFromColor(fp + off, fromTexture, ratio, _fromR);
        return float4(cn.r, c.g, cp.b, c.a);
    }
}

