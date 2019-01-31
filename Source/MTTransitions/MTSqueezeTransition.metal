// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;
 
 

//fragment float4 SqueezeFragment(VertexOut vertexIn [[ stage_in ]],
//                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
//                texture2d<float, access::sample> toTexture [[ texture(1) ]],
//                constant float & colorSeparation [[ buffer(0) ]],
//                constant float & ratio [[ buffer(1) ]],
//                constant float & progress [[ buffer(2) ]],
//                sampler textureSampler [[ sampler(0) ]]) 
//{
//    float2 uv = vertexIn.textureCoordinate;
//    float _fromR = fromTexture.get_width()/fromTexture.get_height();
//    float _toR = toTexture.get_width()/toTexture.get_height();
//    
//  float y = 0.5 + (uv.y-0.5) / (1.0-progress);
//  if (y < 0.0 || y > 1.0) {
//     return getFromColor(uv, toTexture, ratio, _toR);
//  }
//  else {
//    float2 fp = float2(uv.x, y);
//    float2 off = progress * float2(0.0, colorSeparation);
//    float4 c = getFromColor(fp);
//    float4 cn = getFromColor(fp - off);
//    float4 cp = getFromColor(fp + off);
//    return float4(cn.r, c.g, cp.b, c.a);
//  }
//}

