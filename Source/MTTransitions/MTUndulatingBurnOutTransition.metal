// License: MIT
// Author: pthrasher
// adapted by gre from https://gist.github.com/pthrasher/8e6226b215548ba12734

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

/*
float quadraticInOut(float t) {
    float p = 2.0 * t * t;
    return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float getGradient(float r, float dist, float smoothness) {
    float d = r - dist;
    return mix(
               smoothstep(-smoothness, 0.0, r - dist * (1.0 + smoothness)),
               -1.0 - step(0.005, d),
               step(-0.005, d) * step(d, 0.01)
               );
}

float getWave(float2 p, float2 center, float progress){
    float2 _p = p - center; // offset from center
    float rads = atan2(_p.y, _p.x);
    float degs = degrees(rads) + 180.0;
    float2 range = float2(0.0, M_PI * 30.0);
    float2 domain = float2(0.0, 360.0);
    float ratio = (M_PI * 30.0) / 360.0;
    degs = degs * ratio;
    float x = progress;
    float magnitude = mix(0.02, 0.09, smoothstep(0.0, 1.0, x));
    float offset = mix(40.0, 30.0, smoothstep(0.0, 1.0, x));
    float ease_degs = quadraticInOut(sin(degs));
    float deg_wave_pos = (ease_degs * magnitude) * sin(x * offset);
    return x + deg_wave_pos;
}
*/

//
//float4 transition(float2 p) {
//  float dist = distance(center, p);
//  float m = getGradient(getWave(p), dist);
//  float4 cfrom = getFromColor(p);
//  float4 cto = getToColor(p);
//  return mix(mix(cfrom, cto, m), mix(cfrom, float4(color, 1.0), 0.75), step(m, -2.0));
//}
//
