// Author: bobylito
// license: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 PolkaDotsCurtainFragment(VertexOut vertexIn [[ stage_in ]],
                                         texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                         texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                         constant float & dots [[ buffer(0) ]],
                                         constant float2 & center [[ buffer(1) ]],
                                         constant float & ratio [[ buffer(2) ]],
                                         constant float & progress [[ buffer(3) ]],
                                         sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    //const float SQRT_2 = 1.414213562373;
    bool nextImage = distance(fract(uv * dots), float2(0.5, 0.5)) < ( progress / distance(uv, center));
    return nextImage ? getToColor(uv, toTexture, ratio, _toR) : getFromColor(uv, fromTexture, ratio, _fromR);
}
