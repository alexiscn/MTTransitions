// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

// TODO

float2 cube_project (float2 p, float floating) {
    return p * float2(1.0, -1.2) + float2(0.0, -floating/100.);
}

bool cube_inBounds (float2 p) {
    return all(float2(0.0) < p) && all(p < float2(1.0));
}
//
//float4 bgColor (float2 p, float2 pfr, float2 pto) {
//  float4 c = float4(0.0, 0.0, 0.0, 1.0);
//  pfr = project(pfr);
//  // FIXME avoid branching might help perf!
//  if (inBounds(pfr)) {
//    c += mix(float4(0.0), getFromColor(pfr), reflection * mix(1.0, 0.0, pfr.y));
//  }
//  pto = project(pto);
//  if (inBounds(pto)) {
//    c += mix(float4(0.0), getToColor(pto), reflection * mix(1.0, 0.0, pto.y));
//  }
//  return c;
//}
//
// p : the position
// persp : the perspective in [ 0, 1 ]
// center : the xcenter in [0, 1] \ 0.5 excluded
//float2 cube_xskew (float2 p, float persp, float center) {
//    float x = mix(p.x, 1.0-p.x, center);
//    return (
//            (
//             float2( x, (p.y - 0.5*(1.0-persp) * x) / (1.0+(persp-1.0)*x) )
//             - float2(0.5-distance(center, 0.5), 0.0)
//             )
//            * float2(0.5 / distance(center, 0.5) * (center<0.5 ? 1.0 : -1.0), 1.0)
//            + float2(center<0.5 ? 0.0 : 1.0, 0.0)
//            );
//}

//float4 transition(float2 op) {
//  float uz = unzoom * 2.0*(0.5-distance(0.5, progress));
//  float2 p = -uz*0.5+(1.0+uz) * op;
//  float2 fromP = xskew(
//    (p - float2(progress, 0.0)) / float2(1.0-progress, 1.0),
//    1.0-mix(progress, 0.0, persp),
//    0.0
//  );
//  float2 toP = xskew(
//    p / float2(progress, 1.0),
//    mix(pow(progress, 2.0), 1.0, persp),
//    1.0
//  );
//  // FIXME avoid branching might help perf!
//  if (inBounds(fromP)) {
//    return getFromColor(fromP);
//  }
//  else if (inBounds(toP)) {
//    return getToColor(toP);
//  }
//  return bgColor(op, fromP, toP);
//}

