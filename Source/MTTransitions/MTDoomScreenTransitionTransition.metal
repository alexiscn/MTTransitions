// Author: Zeh Fernando
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;


// Transition parameters --------

// Number of total bars/columns

// Multiplier for speed ratio. 0 = no variation when going down, higher = some elements go much faster

// Further variations in speed. 0 = no noise, 1 = super noisy (ignore frequency)

// Speed variation horizontally. the bigger the value, the shorter the waves

// How much the bars seem to "run" from the middle of the screen first (sticking to the sides). 0 = no drip, 1 = curved drip


// The code proper --------

//float rand(int num) {
//  return fract(mod(float(num) * 67123.313, 12.0) * sin(float(num) * 10.3) * cos(float(num)));
//}
//
//float wave(int num) {
//  float fn = float(num) * frequency * 0.1 * float(bars);
//  return cos(fn * 0.5) * cos(fn * 0.13) * sin((fn+10.0) * 0.3) / 2.0 + 0.5;
//}
//
//float drip(int num) {
//  return sin(float(num) / float(bars - 1) * 3.141592) * dripScale;
//}
//
//float pos(int num) {
//  return (noise == 0.0 ? wave(num) : mix(wave(num), rand(num), noise)) + (dripScale == 0.0 ? 0.0 : drip(num));
//}
//
//float4 transition(float2 uv) {
//  int bar = int(uv.x * (float(bars)));
//  float scale = 1.0 + pos(bar) * amplitude;
//  float phase = progress * scale;
//  float posY = uv.y / float2(1.0).y;
//  float2 p;
//  float4 c;
//  if (phase + posY < 1.0) {
//    p = float2(uv.x, uv.y + mix(0.0, float2(1.0).y, phase)) / float2(1.0).xy;
//    c = getFromColor(p);
//  } else {
//    p = uv.xy / float2(1.0).xy;
//    c = getToColor(p);
//  }
//
//  // Finally, apply the color
//  return c;
//}

