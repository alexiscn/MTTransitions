// License: MIT
// Author: Xaychru

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;
// ported by gre from https://gist.github.com/Xaychru/130bb7b7affedbda9df5

#define POW2(X) X*X
#define POW3(X) X*X*X

//float2 Rotate(float2 v, float a) {
//  mat2 rm = mat2(cos(a), -sin(a),
//                 sin(a), cos(a));
//  return rm*v;
//}
//float CosInterpolation(float x) {
//  return -cos(x*PI)/2.+.5;
//}
//float4 transition(float2 uv) {
//  float2 p = uv.xy / float2(1.0).xy - .5;
//  float2 rp = p;
//  float rpr = (progress*2.-1.);
//  float z = -(rpr*rpr*2.) + 3.;
//  float az = abs(z);
//  rp *= az;
//  rp += mix(float2(.5, .5), float2(float(endx) + .5, float(endy) + .5), POW2(CosInterpolation(progress)));
//  float2 mrp = mod(rp, 1.);
//  float2 crp = rp;
//  bool onEnd = int(floor(crp.x))==endx&&int(floor(crp.y))==endy;
//  if(!onEnd) {
//    float ang = float(int(Rand(floor(crp))*4.))*.5*PI;
//    mrp = float2(.5) + Rotate(mrp-float2(.5), ang);
//  }
//  if(onEnd || Rand(floor(crp))>.5) {
//    return getToColor(mrp);
//  } else {
//    return getFromColor(mrp);
//  }
//}

