// Author: gre
// license: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 LinearBlurFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & intensity [[ buffer(0) ]],
                                   constant float & ratio [[ buffer(1) ]],
                                   constant float & progress [[ buffer(2) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    float _fromR = fromTexture.get_width()/fromTexture.get_height();
    float _toR = toTexture.get_width()/toTexture.get_height();

    const int passes = 6;
    float4 c1 = float4(0.0);
    float4 c2 = float4(0.0);
//    float disp = intensity * (0.5 - distance(0.5, progress));
    float disp = intensity * (0.5 - (0.5 - progress));
    for (int xi = 0; xi < passes; xi++) {
        float x = float(xi) / float(passes) - 0.5;
        for (int yi=0; yi<passes; yi++)
        {
            float y = float(yi) / float(passes) - 0.5;
            float2 v = float2(x, y);
            float d = disp;
            c1 += getFromColor( uv + d*v, fromTexture, ratio, _fromR);
            c2 += getToColor( uv + d*v, toTexture, ratio, _toR);
        }
    }
    c1 /= float(passes*passes);
    c2 /= float(passes*passes);
    return mix(c1, c2, progress);
}
