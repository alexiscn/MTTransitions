// Author: Hewlett-Packard
// License: BSD 3 Clause
// Adapted by Sergey Kosarevsky from:
// http://rectalogic.github.io/webvfx/examples_2transition-shader-pagecurl_8html-example.html

/*
 Copyright (c) 2010 Hewlett-Packard Development Company, L.P. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above
 copyright notice, this list of conditions and the following disclaimer
 in the documentation and/or other materials provided with the
 distribution.
 * Neither the name of Hewlett-Packard nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 in float2 texCoord;
 */

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

constexpr constant float scale = 512.0;
constexpr constant float sharpness = 3.0;
constexpr constant float cylinderRadius = 1.0/M_PI_F/2.0;

float3 hitPoint(float hitAngle, float yc, float3 point, float3x3 rrotation) {
    float hitPoint = hitAngle / (2.0 * M_PI_F);
    point.y = hitPoint;
    return rrotation * point;
}

float4 antiAlias(float4 color1, float4 color2, float distanc){
    float distance = distanc * scale;
    if (distance < 0.0) {
        return color2;
    }
    if (distance > 2.0) {
        return color1;
    }
    float dd = pow(1.0 - distance / 2.0, sharpness);
    return ((color2 - color1) * dd) + color1;
}

float distanceToEdge(float3 point) {
    float dx = abs(point.x > 0.5 ? 1.0 - point.x : point.x);
    float dy = abs(point.y > 0.5 ? 1.0 - point.y : point.y);
    if (point.x < 0.0) {
        dx = -point.x;
    }
    if (point.x > 1.0) {
        dx = point.x - 1.0;
    }
    if (point.y < 0.0) {
        dy = -point.y;
    }
    if (point.y > 1.0) {
        dy = point.y - 1.0;
    }
    if ((point.x < 0.0 || point.x > 1.0) && (point.y < 0.0 || point.y > 1.0)) {
        return sqrt(dx * dx + dy * dy);
    }
    return min(dx, dy);
}

float4 seeThrough(float yc, float2 p, float3x3 rotation, float3x3 rrotation,
                  float amount, float ratio,
                  texture2d<float, access::sample> fromTexture, float _fromR,
                  texture2d<float, access::sample> toTexture, float _toR) {

    float cylinderAngle = 2.0 * M_PI_F * amount;
    float hitAngle = M_PI_F - (acos(yc / cylinderRadius) - cylinderAngle);
    float3 point = hitPoint(hitAngle, yc, rotation * float3(p, 1.0), rrotation);
    if (yc <= 0.0 && (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0)) {
        return getToColor(p, toTexture, ratio, _toR);
    }
    
    if (yc > 0.0) {
        return getFromColor(p, fromTexture, ratio, _fromR);
    }
    
    float4 color = getFromColor(point.xy, fromTexture, ratio, _fromR);
    float4 tcolor = float4(0.0);
    
    return antiAlias(color, tcolor, distanceToEdge(point));
}

float4 seeThroughWithShadow(float yc, float2 p, float3 point, float3x3 rotation, float3x3 rrotation,
                            float amount, float ratio,
                            texture2d<float, access::sample> fromTexture, float _fromR,
                            texture2d<float, access::sample> toTexture, float _toR) {
    float shadow = distanceToEdge(point) * 30.0;
    shadow = (1.0 - shadow) / 3.0;
    
    if (shadow < 0.0) {
        shadow = 0.0;
    } else {
        shadow = shadow * amount;
    }
    
    float4 shadowColor = seeThrough(yc, p, rotation, rrotation, amount, ratio, fromTexture, _fromR, toTexture, _toR);
    shadowColor.r = shadowColor.r - shadow;
    shadowColor.g = shadowColor.g - shadow;
    shadowColor.b = shadowColor.b - shadow;
    
    return shadowColor;
}

float4 backside(float yc, float3 point, float ratio, texture2d<float, access::sample> fromTexture, float _fromR) {
    float4 color = getFromColor(point.xy, fromTexture, ratio, _fromR);
    float gray = (color.r + color.b + color.g) / 15.0;
    gray += (8.0 / 10.0) * (pow(1.0 - abs(yc/cylinderRadius), 2.0 / 10.0) / 2.0 + (5.0 / 10.0));
    color.rgb = float3(gray);
    return color;
}

float4 behindSurface(float2 p, float yc, float3 point, float3x3 rrotation,float amount, float cylinderAngle, float ratio, texture2d<float, access::sample> toTexture, float _toR) {
    float cylinderRadius =  1.0/M_PI_F/2.0;
    float shado = (1.0 - ((-cylinderRadius - yc) / amount * 7.0)) / 6.0;
    shado *= 1.0 - abs(point.x - 0.5);
    
    yc = (-cylinderRadius - cylinderRadius - yc);
    
    float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - M_PI_F;
    point = hitPoint(hitAngle, yc, point, rrotation);
    
    if (yc < 0.0 && point.x >= 0.0 && point.y >= 0.0 && point.x <= 1.0 && point.y <= 1.0 && (hitAngle < M_PI_F || amount > 0.5)) {
        shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / (71.0 / 100.0));
        shado *= pow(-yc / cylinderRadius, 3.0);
        shado *= 0.5;
    } else {
        shado = 0.0;
    }
    return float4(getToColor(p, toTexture, ratio, _toR).rgb - shado, 1.0);
}


fragment float4 InvertedPageCurlFragment(VertexOut vertexIn [[ stage_in ]],
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
    
    const float MIN_AMOUNT = -0.16;
    const float MAX_AMOUNT = 1.3;
    float amount = progress * (MAX_AMOUNT - MIN_AMOUNT) + MIN_AMOUNT;
    float cylinderCenter = amount;
    float cylinderAngle = 2.0 * M_PI_F * amount; // 360 degrees * amount
    
    const float angle = 100.0 * M_PI_F / 180.0;
    float c = cos(-angle);
    float s = sin(-angle);
    
    float3x3 rotation = float3x3(float3(c, s, 0),
                                 float3(-s, c, 0),
                                 float3(-0.801, 0.8900, 1));
    c = cos(angle);
    s = sin(angle);
    
    float3x3 rrotation = float3x3(float3(c, s, 0),
                                  float3(-s, c, 0),
                                  float3(0.98500, 0.985, 1));
    
    float3 point = rotation * float3(uv, 1.0);
    
    float yc = point.y - cylinderCenter;
    
    if (yc < -cylinderRadius) {
        // Behind surface
        return behindSurface(uv, yc, point, rrotation, amount, cylinderAngle, ratio, toTexture, _toR);
    }
    
    if (yc > cylinderRadius) {
        // Flat surface
        return getFromColor(uv, fromTexture, ratio, _fromR);
    }
    
    float hitAngle = (acos(yc/cylinderRadius) + cylinderAngle) - M_PI_F;
    float hitAngleMod = mod(hitAngle, 2.0 * M_PI_F);
    if ((hitAngleMod > M_PI_F && amount < 0.5) || (hitAngleMod > M_PI_F/2.0 && amount < 0.0)) {
        return seeThrough(yc, uv, rotation, rrotation, amount, ratio, fromTexture, _fromR, toTexture, _toR);
    }
    
    point = hitPoint(hitAngle, yc, point, rrotation);
    
    if (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0) {
        return seeThroughWithShadow(yc, uv, point, rotation, rrotation, amount, ratio, fromTexture, _fromR, toTexture, _toR);
    }
    
    float4 color = backside(yc, point, ratio, fromTexture, _fromR);
    
    float4 otherColor;
    if (yc < 0.0) {
        float shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / 0.71);
        shado *= pow(-yc / cylinderRadius, 3.0);
        shado *= 0.5;
        otherColor = float4(0.0, 0.0, 0.0, shado);
    } else {
        otherColor = getFromColor(uv, fromTexture, ratio, _fromR);
    }
    
    color = antiAlias(color, otherColor, cylinderRadius - abs(yc));
    
    float4 cl = seeThroughWithShadow(yc, uv, point, rotation, rrotation, amount, ratio, fromTexture, _fromR, toTexture, _toR);
    float dist = distanceToEdge(point);
    
    return antiAlias(color, cl, dist);
}
