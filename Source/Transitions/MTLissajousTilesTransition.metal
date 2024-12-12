// Name: Lissajous Tiles
// Author: Boundless <info@boundless-beta.com>
// License: MIT
// <3

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 LissajousTilesFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & speed [[ buffer(0) ]],
                                   constant float2 & freq [[ buffer(1) ]],
                                   constant float & offset [[ buffer(2) ]],
                                   constant float & zoom [[ buffer(3) ]],
                                   constant float & fade [[ buffer(4) ]],
                                   constant float & ratio [[ buffer(5) ]],
                                   constant float & progress [[ buffer(6) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    const float2 grid = float2(10.,10.); // grid size
    float4 col = float4(0.);
    float p = 1.-pow(abs(1.-2.*progress),3.); // transition curve
    for (float h = 0.; h < grid.x*grid.y; h+=1.) {
        float iBig = mod(h,grid.x);
        float jBig = floor(h / grid.x);
        float i = iBig/grid.x;
        float j = jBig/grid.y;
        float2 uv0 = (uv + float2(i,j) - 0.5 + 0.5/grid + float2(cos((i/grid.y+j)*6.28*freq.x+progress*6.*speed)*zoom/2.,sin((i/grid.y+j)*6.28*freq.y+progress*6.*(1.+offset)*speed)*zoom/2.));
        uv0 = uv0*p + uv*(1.-p);
        bool m = uv0.x > i && uv0.x < (i+1./grid.x) && uv0.y > j && uv0.y < (j+1./grid.x); // mask for each (i,j) tile
        col *= 1.-float(m);
        col += mix(
                   getFromColor(uv0, fromTexture, ratio, _fromR),
                   getToColor(uv0, toTexture, ratio, _toR),
                   min(max((progress)*(((1.+fade)*2.)*progress)-(fade)+(i/grid.y+j)*(fade),0.),1.)
                   )*float(m);
    }
    return col;
}
