// License: MIT
// Author: dycm8009
// ported by gre from https://gist.github.com/dycm8009/948e99b1800e81ad909a

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 zoom(float2 uv, float amount) {
    return 0.5 + ((uv - 0.5) * amount);
}

fragment float4 ZoomInCirclesFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    // TODO: some timing are hardcoded but should be one or many parameters
    // TODO: should also be able to configure how much circles
    // TODO: if() branching should be avoided when possible, prefer use of step() & other functions
    float2 ratio2 = float2(1.0, 1.0 / ratio);
    float2 r = 2.0 * ((float2(uv.xy) - 0.5) * ratio2);
    float pro = progress / 0.8;
    float z = pro * 0.2;
    float t = 0.0;
    if (pro > 1.0) {
        z = 0.2 + (pro - 1.0) * 5.;
        t = clamp((progress - 0.8) / 0.07, 0.0, 1.0);
    }
    if (length(r) < 0.5+z) {
        // uv = zoom(uv, 0.9 - 0.1 * pro);
    }
    else if (length(r) < 0.8+z*1.5) {
        uv = zoom(uv, 1.0 - 0.15 * pro);
        t = t * 0.5;
    } else if (length(r) < 1.2+z*2.5) {
        uv = zoom(uv, 1.0 - 0.2 * pro);
        t = t * 0.2;
    } else {
        uv = zoom(uv, 1.0 - 0.25 * pro);
    }
    return mix(
               getFromColor(uv, fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               t);
}
