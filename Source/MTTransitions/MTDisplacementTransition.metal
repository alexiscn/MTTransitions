// Author: Travis Fischer
// License: MIT
//
// Adapted from a Codrops article by Robin Delaporte
// https://tympanus.net/Development/DistortionHoverEffect

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

//fragment float4 DisplacementFragment(VertexOut vertexIn [[ stage_in ]],
//                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
//                texture2d<float, access::sample> toTexture [[ texture(1) ]],
//                constant float & strength [[ buffer(0) ]],
//                constant sampler & displacementMap [[ buffer(1) ]],
//                constant float & ratio [[ buffer(2) ]],
//                constant float & progress [[ buffer(3) ]],
//                sampler textureSampler [[ sampler(0) ]])
//{
//    float2 uv = vertexIn.textureCoordinate;
//    float _fromR = fromTexture.get_width()/fromTexture.get_height();
//    float _toR = toTexture.get_width()/toTexture.get_height();
//    
//
//    float displacement = texture2D(displacementMap, uv).r * strength;
//
//    float2 uvFrom = float2(uv.x + progress * displacement, uv.y);
//    float2 uvTo = float2(uv.x - (1.0 - progress) * displacement, uv.y);
//
//  return mix(
//             getFromColor(uvFrom, fromTexture, ratio, _fromR),
//             getToColor(uvTo, toTexture, ratio, _toR),
//             progress
//             );
//}

