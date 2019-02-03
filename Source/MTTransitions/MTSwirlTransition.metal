// License: MIT
// Author: Sergey Kosarevsky
// ( http://www.linderdaum.com )
// ported by gre from https://gist.github.com/corporateshark/cacfedb8cca0f5ce3f7c

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 SwirlFragment(VertexOut vertexIn [[ stage_in ]],
                              texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                              texture2d<float, access::sample> toTexture [[ texture(1) ]],
                              constant float & ratio [[ buffer(0) ]],
                              constant float & progress [[ buffer(1) ]],
                              sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float radius = 1.0;
    float t = progress;
    uv -= float2( 0.5, 0.5 );
    float dist = length(uv);
    
    if (dist < radius) {
        float percent = (radius - dist) / radius;
        float a = (t <= 0.5 ) ? mix( 0.0, 1.0, t/0.5) : mix( 1.0, 0.0, (t-0.5)/0.5 );
        float theta = percent * percent * a * 8.0 * 3.14159;
        float s = sin(theta);
        float c = cos(theta);
        uv = float2(dot(uv, float2(c, -s)), dot(uv, float2(s, c)) );
    }
    uv += float2( 0.5, 0.5 );

    float4 c0 = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 c1 = getToColor(uv, toTexture, ratio, _toR);

    return mix(c0, c1, t);
}
