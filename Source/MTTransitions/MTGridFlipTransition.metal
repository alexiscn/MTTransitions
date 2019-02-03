// License: MIT
// Author: TimDonselaar
// ported by gre from https://gist.github.com/TimDonselaar/9bcd1c4b5934ba60087bdb55c2ea92e5

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

float getDelta(float2 p, int2 size) {
    float2 rectanglePos = floor(float2(size) * p);
    float2 rectangleSize = float2(1.0 / float2(size).x, 1.0 / float2(size).y);
    float top = rectangleSize.y * (rectanglePos.y + 1.0);
    float bottom = rectangleSize.y * rectanglePos.y;
    float left = rectangleSize.x * rectanglePos.x;
    float right = rectangleSize.x * (rectanglePos.x + 1.0);
    float minX = min(abs(p.x - left), abs(p.x - right));
    float minY = min(abs(p.y - top), abs(p.y - bottom));
    return min(minX, minY);
}

float getDividerSize(int2 size, float dividerWidth) {
    float2 rectangleSize = float2(1.0 / float2(size).x, 1.0 / float2(size).y);
    return min(rectangleSize.x, rectangleSize.y) * dividerWidth;
}

fragment float4 GridFlipFragment(VertexOut vertexIn [[ stage_in ]],
                                 texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                 texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                 constant float4 & bgcolor [[ buffer(0) ]],
                                 constant float & randomness [[ buffer(1) ]],
                                 constant float & pause [[ buffer(2) ]],
                                 constant float & dividerWidth [[ buffer(3) ]],
                                 constant int2 & size [[ buffer(4) ]],
                                 constant float & ratio [[ buffer(5) ]],
                                 constant float & progress [[ buffer(6) ]],
                                 sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    if(progress < pause) {
        float currentProg = progress / pause;
        float a = 1.0;
        if(getDelta(uv, size) < getDividerSize(size, dividerWidth)) {
            a = 1.0 - currentProg;
        }
        return mix(bgcolor, getFromColor(uv, fromTexture, ratio, _fromR), a);
    } else if(progress < 1.0 - pause){
        if(getDelta(uv, size) < getDividerSize(size, dividerWidth)) {
            return bgcolor;
        } else {
            float currentProg = (progress - pause) / (1.0 - pause * 2.0);
            float2 q = uv;
            float2 rectanglePos = floor(float2(size) * q);
            
            float r = rand(rectanglePos) - randomness;
            float cp = smoothstep(0.0, 1.0 - r, currentProg);
            
            float rectangleSize = 1.0 / float2(size).x;
            float delta = rectanglePos.x * rectangleSize;
            float offset = rectangleSize / 2.0 + delta;
            
            uv.x = (uv.x - offset)/abs(cp - 0.5)*0.5 + offset;
            float4 a = getFromColor(uv, fromTexture, ratio, _fromR);
            float4 b = getToColor(uv, toTexture, ratio, _toR);
            
            float s = step(abs(float2(size).x * (q.x - delta) - 0.5), abs(cp - 0.5));
            return mix(bgcolor, mix(b, a, step(cp, 0.5)), s);
        }
    } else {
        float currentProg = (progress - 1.0 + pause) / pause;
        float a = 1.0;
        if(getDelta(uv, size) < getDividerSize(size, dividerWidth)) {
            a = currentProg;
        }
        return mix(bgcolor, getToColor(uv, toTexture, ratio, _toR), a);
    }
}
