// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 FlyeyeFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant float & colorSeparation [[ buffer(0) ]],
                               constant float & zoom [[ buffer(1) ]],
                               constant float & size [[ buffer(2) ]],
                               constant float & ratio [[ buffer(3) ]],
                               constant float & progress [[ buffer(4) ]],
                               sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float inv = 1.0 - progress;
    float2 disp = size*float2(cos(zoom*uv.x), sin(zoom*uv.y));
    float4 texTo = getToColor(uv + inv*disp, toTexture, ratio, _toR);
    float4 texFrom = float4(getFromColor(uv + progress*disp*(1.0 - colorSeparation), fromTexture, ratio, _fromR).r,
                            getFromColor(uv + progress*disp, fromTexture, ratio, _fromR).g,
                            getFromColor(uv + progress*disp*(1.0 + colorSeparation), fromTexture, ratio, _fromR).b,
                            1.0);
    return texTo*progress + texFrom*inv;
    
}
