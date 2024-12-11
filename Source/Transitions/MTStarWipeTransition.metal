// Author:Ben Lucas
// License: MIT

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

#define PI 3.141592653589793
#define STAR_ANGLE 1.2566370614359172

float2 rotate(float2 v, float theta) {
    float cosTheta = cos(theta);
    float sinTheta = sin(theta);
    
    return float2(
                cosTheta * v.x - sinTheta * v.y,
                sinTheta * v.x + cosTheta * v.y
                );
}

bool inStar(float2 uv, float2 center, float radius, float starRotation){
    float2 uv_centered = uv - center;
    uv_centered = rotate(uv_centered, starRotation * STAR_ANGLE);
    float theta = atan2(uv_centered.y, uv_centered.x) + PI;
    
    float2 uv_rotated = rotate(uv_centered, -STAR_ANGLE * (floor(theta / STAR_ANGLE) + 0.5));
    
    float slope = 0.3;
    if(uv_rotated.y > 0.0){
        return (radius + uv_rotated.x * slope > uv_rotated.y);
    } else{
        return (-radius - uv_rotated.x * slope < uv_rotated.y);
    }
}

fragment float4 StarWipeFragment(VertexOut vertexIn [[ stage_in ]],
                                 texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                 texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                 constant float & borderThickness [[ buffer(0) ]],
                                 constant float & starRotation [[ buffer(1) ]],
                                 constant float4 & borderColor [[ buffer(2) ]],
                                 constant float2 & starCenter [[ buffer(3) ]],
                                 constant float & ratio [[ buffer(4) ]],
                                 constant float & progress [[ buffer(5) ]],
                                 sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float progressScaled = (2.0 * borderThickness + 1.0) * progress - borderThickness;
    if(inStar(uv, starCenter, progressScaled, starRotation)){
        return getToColor(uv, toTexture, ratio, _toR);
    } else if(inStar(uv, starCenter, progressScaled+borderThickness, starRotation)){
        return borderColor;
    }
    else{
        return getFromColor(uv, fromTexture, ratio, _fromR);
    }
}
