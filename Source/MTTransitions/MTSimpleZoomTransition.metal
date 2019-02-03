// Author: 0gust1
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float2 simple_zoom(float2 uv, float amount) {
    return 0.5 + ((uv - 0.5) * (1.0-amount));
}

fragment float4 SimpleZoomFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float & zoomQuickness [[ buffer(0) ]],
                                   constant float & ratio [[ buffer(1) ]],
                                   constant float & progress [[ buffer(2) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float nQuick = clamp(zoomQuickness,0.2,1.0);
    
    return mix(getFromColor(simple_zoom(uv, smoothstep(0.0, nQuick, progress)), fromTexture, ratio, _fromR),
               getToColor(uv, toTexture, ratio, _toR),
               smoothstep(nQuick-0.2, 1.0, progress)
               );
}
