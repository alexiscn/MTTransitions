// Name: Power Kaleido
// Author: Boundless
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 refl(float2 p,float2 o,float2 n)
{
    return 2.0*o+2.0*n*dot(p-o,n)-p;
}

float2 rot(float2 p, float2 o, float a)
{
    float s = sin(a);
    float c = cos(a);
    return o + float2x2(float2(c, -s), float2(s, c)) * (p - o);
}

fragment float4 PowerKaleidoFragment(VertexOut vertexIn [[ stage_in ]],
                                     texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                     texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                     constant float & scale [[ buffer(0) ]],
                                     constant float & z [[ buffer(1) ]],
                                     constant float & speed [[ buffer(2) ]],
                                     constant float & ratio [[ buffer(3) ]],
                                     constant float & progress [[ buffer(4) ]],
                                     sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());

    const float rad = 120.; // change this value to get different mirror effects
    const float deg = rad / 180. * PI;
    float dist = scale / 10.0;
    
    float2 uv0 = uv;
    uv -= 0.5;
    uv.x *= ratio;
    uv *= z;
    uv = rot(uv, float2(0.0), progress*speed);
    // uv.x = fract(uv.x/l/3.0)*l*3.0;
    //float theta = progress*6.+PI/.5;
    for(int iter = 0; iter < 10; iter++) {
    for(float i = 0.; i < 2. * PI; i+=deg) {
        float ts = sign(asin(cos(i))) == 1.0 ? 1.0 : 0.0;
        if(((ts == 1.0) && (uv.y-dist*cos(i) > tan(i)*(uv.x+dist*+sin(i)))) || ((ts == 0.0) && (uv.y-dist*cos(i) < tan(i)*(uv.x+dist*+sin(i))))) {
            uv = refl(float2(uv.x+sin(i)*dist*2.,uv.y-cos(i)*dist*2.), float2(0.,0.), float2(cos(i),sin(i)));
          }
        }
    }
    uv += 0.5;
    uv = rot(uv, float2(0.5), progress*-speed);
    uv -= 0.5;
    uv.x /= ratio;
    uv += 0.5;
    uv = 2.*abs(uv/2.-floor(uv/2.+0.5));
    float2 uvMix = mix(uv,uv0,cos(progress*PI*2.)/2.+0.5);
    float4 color = mix(getFromColor(uvMix, fromTexture, ratio, _fromR),
                         getToColor(uvMix, toTexture, ratio, _toR),cos((progress-1.)*PI)/2.+0.5);
    return color;
}
