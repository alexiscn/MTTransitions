// Author: Mark Craig
// License: MIT

//  MTSlidesTransition.metal
//  MTTransitions
//
//  Created by Nazmul on 04/08/2022.

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

#define rad2 rad / 2.0

fragment float4 SlidesFragment(VertexOut vertexIn [[ stage_in ]],
                             texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                             texture2d<float, access::sample> toTexture [[ texture(1) ]],
                             constant float & type [[ buffer(0) ]],
                             constant float & In [[ buffer(1) ]],
                             constant float & ratio [[ buffer(2) ]],
                             constant float & progress [[ buffer(3) ]],
                             sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float2 uv0 = uv;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    float rad = In ? progress : 1.0 - progress;
    
    float xc1, yc1;
    // I used if/else instead of switch in case it's an old GPU
    if (type == 0) { xc1 = .5 - rad2; yc1 = 0.0; }
    else if (type == 1) { xc1 = 1.0 - rad; yc1 = .5 - rad2; }
    else if (type == 2) { xc1 = .5 - rad2; yc1 = 1.0 - rad; }
    else if (type == 3) { xc1 = 0.0; yc1 = .5 - rad2; }
    else if (type == 4) { xc1 = 1.0 - rad; yc1 = 0.0; }
    else if (type == 5) { xc1 = 1.0 - rad; yc1 = 1.0 - rad; }
    else if (type == 6) { xc1 = 0.0; yc1 = 1.0 - rad; }
    else if (type == 7) { xc1 = 0.0; yc1 = 0.0; }
    else { xc1 = .5 - rad2; yc1 = .5 - rad2; }
    float2 uv2;
    
    if ((uv.x >= xc1) && (uv.x <= xc1 + rad) && (uv.y >= yc1)
        && (uv.y <= yc1 + rad)) {
        uv2 = float2((uv.x - xc1) / rad, 1.0 - (uv.y - yc1) / rad);
        uv2.y = 1.0 - uv2.y;
        return  In ? getToColor(uv2, toTexture, ratio, _toR): getFromColor(uv2, fromTexture, ratio,_fromR);
    }
    return  In ? getFromColor(uv0, fromTexture, ratio, _fromR): getToColor(uv0, toTexture, ratio, _toR);
}

