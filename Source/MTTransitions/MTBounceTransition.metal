// Author: Adrian Purser
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 BounceFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant float & bounces [[ buffer(0) ]],
                               constant float4 & shadowColour [[ buffer(1) ]],
                               constant float & shadowHeight [[ buffer(2) ]],
                               constant float & ratio [[ buffer(3) ]],
                               constant float & progress [[ buffer(4) ]],
                               sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float time = progress;
    float stime = sin(time * PI/2.0);
    float phase = time * PI * bounces;
    float y = abs(cos(phase)) * (1 - stime);
    float d = uv.y - y;
    float4 shadow = ((d/shadowHeight) * shadowColour.a) + (1.0 - shadowColour.a);
    float4 smooth = step(d, shadowHeight) * (1.0 - mix(shadow, 1.0, smoothstep(0.95, 1.0, progress)));
    return mix(mix(getToColor(uv, toTexture, ratio, _toR), shadowColour, smooth),
               getFromColor(float2(uv.x, uv.y + (1.0 - y)), fromTexture, ratio, _fromR),
               step(d, 0.0)
    );
}
