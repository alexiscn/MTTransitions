// Author: Yoni Maltsman @friendlyspinach
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 ParametricGlitchFragment(VertexOut vertexIn [[ stage_in ]],
                                         texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                         texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                         constant float & ampx [[ buffer(0) ]],
                                         constant float & ampy [[ buffer(1) ]],
                                         constant float & ratio [[ buffer(2) ]],
                                         constant float & progress [[ buffer(3) ]],
                                         sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 from = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 to = getToColor(uv, toTexture, ratio, _toR);
    float r = from.r;
    float g = from.g;
    float b = from.b;
    float sphere = r*r + g*g + b*b - 1.0; //3 to 1
    float spiralX = cos(sphere - uv.x/(progress + .01));
    float spiralY = sin(sphere - uv.y/(progress+.01));
    float2 st = uv;
    st.x = fract(ampx*st.x*spiralX); //1 to 2
    st.y = fract(ampy*st.y*spiralY);
    float2 diff = uv - st;
    from = getFromColor(uv + progress*diff, fromTexture, ratio, _fromR);
    return mix(from, to, progress);
}
