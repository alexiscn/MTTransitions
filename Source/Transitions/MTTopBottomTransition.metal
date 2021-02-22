// Author:zhmy
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

bool topBottomInBounds(float2 p) {
    const float2 boundMin = float2(0.0, 0.0);
    const float2 boundMax = float2(1.0, 1.0);
    return all(boundMin < p) && all(p < boundMax);
}

fragment float4 TopBottomFragment(VertexOut vertexIn [[ stage_in ]],
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

    float2 spfr,spto = float2(-1.);
    float size = mix(1.0, 3.0, progress*0.2);
    spto = (uv + float2(-0.5,-0.5)) * float2(size,size) + float2(0.5,0.5);
    spfr = (uv + float2(0.0, 1.0 - progress));
    if(topBottomInBounds(spfr)) {
        return getToColor(spfr, toTexture, ratio, _toR);
    } else if(topBottomInBounds(spto)) {
        return getFromColor(spto, fromTexture, ratio, _fromR) * (1.0 - progress);
    } else{
        return float4(0, 0, 0, 1);
    }
}
