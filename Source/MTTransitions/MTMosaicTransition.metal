// License: MIT
// Author: Xaychru
// ported by gre from https://gist.github.com/Xaychru/130bb7b7affedbda9df5

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

#define POW2(X) X*X
#define POW3(X) X*X*X

float2 mosaicRotate(float2 v, float a) {
  float2x2 rm = float2x2(cos(a), -sin(a), sin(a), cos(a));
  return rm*v;
}

float cosInterpolation(float x) {
    return -cos(x*PI)/2.+.5;
}

fragment float4 MosaicFragment(VertexOut vertexIn [[ stage_in ]],
                               texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                               texture2d<float, access::sample> toTexture [[ texture(1) ]],
                               constant int & endy [[ buffer(0) ]],
                               constant int & endx [[ buffer(1) ]],
                               constant float & ratio [[ buffer(2) ]],
                               constant float & progress [[ buffer(3) ]],
                               sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    float _fromR = fromTexture.get_width()/fromTexture.get_height();
    float _toR = toTexture.get_width()/toTexture.get_height();
    
    float2 p = uv.xy / float2(1.0).xy - 0.5;
    float2 rp = p;
    float rpr = (progress*2.-1.);
    float z = -(rpr*rpr*2.) + 3.;
    float az = abs(z);
    rp *= az;
    rp += mix(float2(0.5, 0.5), float2(float(endx) + .5, float(endy) + .5), POW2(cosInterpolation(progress)));
    float2 mrp = fmod(rp, 1.0);
    float2 crp = rp;
    bool onEnd = int(floor(crp.x)) == endx && int(floor(crp.y)) == endy;
    if(!onEnd) {
        float ang = float(int(rand(floor(crp))*4.))*.5*PI;
        mrp = float2(.5) + mosaicRotate(mrp-float2(.5), ang);
    }
    if(onEnd || rand(floor(crp))>.5) {
        return getToColor(mrp, toTexture, ratio, _toR);
    } else {
        return getFromColor(mrp, fromTexture, ratio, _fromR);
    }
}
