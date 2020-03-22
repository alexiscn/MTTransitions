// Author: Fernando Kuteken
// License: MIT
// Hexagonal math from: http://www.redblobgames.com/grids/hexagons/

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

struct Hexagon {
    float q;
    float r;
    float s;
};

Hexagon createHexagon(float q, float r){
    Hexagon hex;
    hex.q = q;
    hex.r = r;
    hex.s = -q - r;
    return hex;
}

Hexagon roundHexagon(Hexagon hex){
    
    float q = floor(hex.q + 0.5);
    float r = floor(hex.r + 0.5);
    float s = floor(hex.s + 0.5);
    
    float deltaQ = abs(q - hex.q);
    float deltaR = abs(r - hex.r);
    float deltaS = abs(s - hex.s);
    
    if (deltaQ > deltaR && deltaQ > deltaS)
        q = -r - s;
    else if (deltaR > deltaS)
        r = -q - s;
    else
        s = -q - r;
    
    return createHexagon(q, r);
}

Hexagon hexagonFromPoint(float2 point, float size, float ratio) {
    
    point.y /= ratio;
    point = (point - 0.5) / size;
    
    float q = (sqrt(3.0) / 3.0) * point.x + (-1.0 / 3.0) * point.y;
    float r = 0.0 * point.x + 2.0 / 3.0 * point.y;
    
    Hexagon hex = createHexagon(q, r);
    return roundHexagon(hex);
    
}

float2 pointFromHexagon(Hexagon hex, float size, float ratio) {
    
    float x = (sqrt(3.0) * hex.q + (sqrt(3.0) / 2.0) * hex.r) * size + 0.5;
    float y = (0.0 * hex.q + (3.0 / 2.0) * hex.r) * size + 0.5;
    
    return float2(x, y * ratio);
}


fragment float4 HexagonalizeFragment(VertexOut vertexIn [[ stage_in ]],
                                     texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                     texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                     constant int & steps [[ buffer(0) ]],
                                     constant float & horizontalHexagons [[ buffer(1) ]],
                                     constant float & ratio [[ buffer(2) ]],
                                     constant float & progress [[ buffer(3) ]],
                                     sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float dist = 2.0 * min(progress, 1.0 - progress);
    dist = steps > 0 ? ceil(dist * float(steps)) / float(steps) : dist;
    
    float size = (sqrt(3.0) / 3.0) * dist / horizontalHexagons;
    
    float2 point = dist > 0.0 ? pointFromHexagon(hexagonFromPoint(uv, size, ratio), size, ratio) : uv;
    
    return mix(getFromColor(point, fromTexture, ratio, _fromR),
               getToColor(point, toTexture, ratio, _toR),
               progress);
    
}

