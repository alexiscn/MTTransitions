// License: MIT
// Author: Xaychru
// ported by gre from https://gist.github.com/Xaychru/ce1d48f0ce00bb379750

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;


//const float PI = 3.141592653589;
//
//float4 transition(float2 p) {
//  float2 rp = p*2.-1.;
//  return mix(
//    getToColor(p),
//    getFromColor(p),
//    smoothstep(0., smoothness, atan(rp.y,rp.x) - (progress-.5) * PI * 2.5)
//  );
//}

