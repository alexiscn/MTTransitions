// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;
 

bool swap_inBounds (float2 p) {
    const float2 boundMin = float2(0.0, 0.0);
    const float2 boundMax = float2(1.0, 1.0);
    return all(boundMin < p) && all(p < boundMax);
}

float2 swap_project (float2 p) {
    return p * float2(1.0, -1.2) + float2(0.0, -0.02);
}

//float4 swap_bgColor (float2 p, float2 pfr, float2 pto) {
//    const float4 black = float4(0.0, 0.0, 0.0, 1.0);
//    float4 c = black;
//    pfr = swap_project(pfr);
//    if (swap_inBounds(pfr)) {
//        c += mix(black, getFromColor(pfr), reflection * mix(1.0, 0.0, pfr.y));
//    }
//    pto = swap_project(pto);
//    if (swap_inBounds(pto)) {
//        c += mix(black, getToColor(pto), reflection * mix(1.0, 0.0, pto.y));
//    }
//    return c;
//}

//float4 transition(float2 p) {
//  float2 pfr, pto = float2(-1.);
// 
//  float size = mix(1.0, depth, progress);
//  float persp = perspective * progress;
//  pfr = (p + float2(-0.0, -0.5)) * float2(size/(1.0-perspective*progress), size/(1.0-size*persp*p.x)) + float2(0.0, 0.5);
// 
//  size = mix(1.0, depth, 1.-progress);
//  persp = perspective * (1.-progress);
//  pto = (p + float2(-1.0, -0.5)) * float2(size/(1.0-perspective*(1.0-progress)), size/(1.0-size*persp*(0.5-p.x))) + float2(1.0, 0.5);
//
//  if (progress < 0.5) {
//    if (inBounds(pfr)) {
//      return getFromColor(pfr);
//    }
//    if (inBounds(pto)) {
//      return getToColor(pto);
//    }  
//  }
//  if (inBounds(pto)) {
//    return getToColor(pto);
//  }
//  if (inBounds(pfr)) {
//    return getFromColor(pfr);
//  }
//  return bgColor(p, pfr, pto);
//}

