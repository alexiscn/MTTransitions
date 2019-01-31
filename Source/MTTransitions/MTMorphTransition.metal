// Author: paniq
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

//float4 transition(float2 p) {
//  float4 ca = getFromColor(p);
//  float4 cb = getToColor(p);
//  
//  float2 oa = (((ca.rg+ca.b)*0.5)*2.0-1.0);
//  float2 ob = (((cb.rg+cb.b)*0.5)*2.0-1.0);
//  float2 oc = mix(oa,ob,0.5)*strength;
//  
//  float w0 = progress;
//  float w1 = 1.0-w0;
//  return mix(getFromColor(p+oc*w0), getToColor(p-oc*w1), progress);
//}
//
