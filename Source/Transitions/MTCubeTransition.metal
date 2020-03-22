// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 cube_project (float2 p, float floating) {
    return p * float2(1.0, -1.2) + float2(0.0, -floating/100.);
}

bool cube_inBounds (float2 p) {
    return all(float2(0.0) < p) && all(p < float2(1.0));
}

// p : the position
// persp : the perspective in [ 0, 1 ]
// center : the xcenter in [0, 1] \ 0.5 excluded
float2 cube_xskew (float2 p, float persp, float center) {
    float x = mix(p.x, 1.0-p.x, center);
    return (
            (float2( x, (p.y - 0.5*(1.0-persp) * x) / (1.0+(persp-1.0)*x) ) - float2(0.5-abs(center - 0.5), 0.0))
            * float2(0.5 / abs(center - 0.5) * (center<0.5 ? 1.0 : -1.0), 1.0)
            + float2(center<0.5 ? 0.0 : 1.0, 0.0)
            );
}

fragment float4 CubeFragment(VertexOut vertexIn [[ stage_in ]],
                             texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                             texture2d<float, access::sample> toTexture [[ texture(1) ]],
                             constant float & persp [[ buffer(0) ]],
                             constant float & unzoom [[ buffer(1) ]],
                             constant float & reflection [[ buffer(2) ]],
                             constant float & floating [[ buffer(3) ]],
                             constant float & ratio [[ buffer(4) ]],
                             constant float & progress [[ buffer(5) ]],
                             sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float uz = unzoom * 2.0*(0.5 - abs(0.5 - progress));
    float2 p = -uz*0.5+(1.0+uz) * uv;
    float2 fromP = cube_xskew((p - float2(progress, 0.0)) / float2(1.0 - progress, 1.0),
                         1.0 - mix(progress, 0.0, persp),
                         0.0);
    float2 toP = cube_xskew(p/float2(progress, 1.0),
                       mix(pow(progress, 2.0), 1.0, persp),
                       1.0);
    // FIXME avoid branching might help perf!
    if (cube_inBounds(fromP)) {
        return getFromColor(fromP, fromTexture, ratio, _fromR);
    } else if (cube_inBounds(toP)) {
        return getToColor(toP, toTexture, ratio, _toR);
    }
    
    float4 c = float4(0.0, 0.0, 0.0, 1.0);
    fromP = cube_project(fromP, floating);
    // FIXME avoid branching might help perf!
    if (cube_inBounds(fromP)) {
        c += mix(float4(0.0), getFromColor(fromP, fromTexture, ratio, _fromR), reflection * mix(1.0, 0.0, fromP.y));
    }
    toP = cube_project(toP, floating);
    if (cube_inBounds(toP)) {
        c += mix(float4(0.0), getToColor(toP, toTexture, ratio, _toR), reflection * mix(1.0, 0.0, toP.y));
    }
    return c;
}
