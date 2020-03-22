// Author: Ted Schundler
// License: BSD 2 Clause
// Free for use and modification by anyone with credit

// Copyright (c) 2016, Theodore K Schundler
// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

///////////////////////////////////////////////////////////////////////////////
// Stereo Viewer Toy Transition                                              //
//                                                                           //
// Inspired by ViewMaster / Image3D image viewer devices.                    //
// This effect is similar to what you see when you press the device's lever. //
// There is a quick zoom in / out to make the transition 'valid' for GLSL.io //
///////////////////////////////////////////////////////////////////////////////

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "MTTransitionLib.h"

using namespace metalpetal;

// TODO

#define black float4(0.0, 0.0, 0.0, 1.0)
#define c00 float2(0.0, 0.0) // the four corner points
#define c01 float2(0.0, 1.0)
#define c11 float2(1.0, 1.0)
#define c10 float2(1.0, 0.0)
//
// Check if a point is within a given corner
bool in_corner(float2 p, float2 corner, float2 radius) {
    // determine the direction we want to be filled
    float2 axis = (c11 - corner) - corner;
    
    // warp the point so we are always testing the bottom left point with the
    // circle centered on the origin
    p = p - (corner + axis * radius);
    p *= axis / radius;
    return (p.x > 0.0 && p.y > -1.0) || (p.y > 0.0 && p.x > -1.0) || dot(p, p) < 1.0;
}

// Check all four corners
// return a float for v2 for anti-aliasing?
bool test_rounded_mask(float2 p, float2 corner_size) {
    return
    in_corner(p, c00, corner_size) &&
    in_corner(p, c01, corner_size) &&
    in_corner(p, c10, corner_size) &&
    in_corner(p, c11, corner_size);
}

// Screen blend mode - https://en.wikipedia.org/wiki/Blend_modes
// This more closely approximates what you see than linear blending
float4 screen(float4 a, float4 b) {
  return 1.0 - (1.0 - a) * (1.0 -b);
}

// Given RGBA, find a value that when screened with itself
// will yield the original value.
float4 unscreen(float4 c) {
  return 1.0 - sqrt(1.0 - c);
}

// Grab a pixel, only if it isn't masked out by the rounded corners
float4 sample_with_corners_from(float2 p, float2 corner_size, float zoom, float ratio, texture2d<float, access::sample> fromTexture, float _fromR) {
    p = (p - 0.5) / zoom + 0.5;
    if (!test_rounded_mask(p, corner_size)) {
        return black;
    }
    return unscreen(getFromColor(p, fromTexture, ratio, _fromR));
}

float4 sample_with_corners_to(float2 p, float2 corner_size, float zoom, float ratio, texture2d<float, access::sample> toTexture, float _toR) {
    p = (p - 0.5) / zoom + 0.5;
    if (!test_rounded_mask(p, corner_size)) {
        return black;
    }
    return unscreen(getToColor(p, toTexture, ratio, _toR));
}

// special sampling used when zooming - extra zoom parameter and don't unscreen
float4 simple_sample_with_corners_from(float2 p, float2 corner_size, float zoom_amt, float zoom, float ratio, texture2d<float, access::sample> fromTexture, float _fromR) {
    p = (p - 0.5) / (1.0 - zoom_amt + zoom * zoom_amt) + 0.5;
    if (!test_rounded_mask(p, corner_size)) {
        return black;
    }
    return getFromColor(p, fromTexture, ratio, _fromR);
}

float4 simple_sample_with_corners_to(float2 p, float2 corner_size, float zoom_amt, float zoom, float ratio, texture2d<float, access::sample> toTexture, float _toR) {
    p = (p - 0.5) / (1.0 - zoom_amt + zoom * zoom_amt) + 0.5;
    if (!test_rounded_mask(p, corner_size)) {
        return black;
    }
    return getToColor(p, toTexture, ratio, _toR);
}


// Basic 2D affine transform matrix helpers
// These really shouldn't be used in a fragment shader - I should work out the
// the math for a translate & rotate function as a pair of dot products instead
float3x3 rotate2d(float angle, float ratio) {
    float s = sin(angle);
    float c = cos(angle);
    return float3x3(float3(c, s ,0.0),
                    float3(-s, c, 0.0),
                    float3(0.0, 0.0, 1.0));
}

float3x3 translate2d(float x, float y) {
    return float3x3(float3(1.0, 0.0, 0),
                    float3(0.0, 1.0, 0),
                    float3(-x, -y, 1.0));
}

float3x3 scale2d(float x, float y) {
    return float3x3(float3(x, 0.0, 0),
                    float3(0.0, y, 0),
                    float3(0, 0, 1.0));
}

// Split an image and rotate one up and one down along off screen pivot points
float4 get_cross_rotated(float3 p3, float angle, float2 corner_size, float ratio, float zoom, texture2d<float, access::sample> fromTexture, float _fromR) {
    angle = angle * angle; // easing
    angle /= 2.4; // works out to be a good number of radians
    
    float3x3 center_and_scale = translate2d(-0.5, -0.5) * scale2d(1.0, ratio);
    float3x3 unscale_and_uncenter = scale2d(1.0, 1.0/ratio) * translate2d(0.5,0.5);
    float3x3 slide_left = translate2d(-2.0,0.0);
    float3x3 slide_right = translate2d(2.0,0.0);
    float3x3 rotate = rotate2d(angle, ratio);
    
    float3x3 op_a = center_and_scale * slide_right * rotate * slide_left * unscale_and_uncenter;
    float3x3 op_b = center_and_scale * slide_left * rotate * slide_right * unscale_and_uncenter;
    
    float4 a = sample_with_corners_from((op_a * p3).xy, corner_size, zoom, ratio, fromTexture, _fromR);
    float4 b = sample_with_corners_from((op_b * p3).xy, corner_size, zoom, ratio, fromTexture, _fromR);
    
    return screen(a, b);
}

// Image stays put, but this time move two masks
float4 get_cross_masked(float3 p3, float angle, float2 corner_size, float ratio, float zoom, texture2d<float, access::sample> toTexture, float _toR) {
    angle = 1.0 - angle;
    angle = angle * angle; // easing
    angle /= 2.4;
    
    float4 img;
    
    float3x3 center_and_scale = translate2d(-0.5, -0.5) * scale2d(1.0, ratio);
    float3x3 unscale_and_uncenter = scale2d(1.0 / zoom, 1.0 / (zoom * ratio)) * translate2d(0.5,0.5);
    float3x3 slide_left = translate2d(-2.0,0.0);
    float3x3 slide_right = translate2d(2.0,0.0);
    float3x3 rotate = rotate2d(angle, ratio);
    
    float3x3 op_a = center_and_scale * slide_right * rotate * slide_left * unscale_and_uncenter;
    float3x3 op_b = center_and_scale * slide_left * rotate * slide_right * unscale_and_uncenter;
    
    bool mask_a = test_rounded_mask((op_a * p3).xy, corner_size);
    bool mask_b = test_rounded_mask((op_b * p3).xy, corner_size);
    
    if (mask_a || mask_b) {
        img = sample_with_corners_to(p3.xy, corner_size, zoom, ratio, toTexture, _toR);
        return screen(mask_a ? img : black, mask_b ? img : black);
    } else {
        return black;
    }
}


fragment float4 StereoViewerFragment(VertexOut vertexIn [[ stage_in ]],
                                     texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                     texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                     constant float & cornerRadius [[ buffer(0) ]],
                                     constant float & zoom [[ buffer(1) ]],
                                     constant float & ratio [[ buffer(2) ]],
                                     constant float & progress [[ buffer(3) ]],
                                     sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float a;
    float2 p = uv.xy/float2(1.0).xy;
    float3 p3 = float3(p.xy, 1.0); // for 2D matrix transforms
    // corner is warped to represent to size after mapping to 1.0, 1.0
    float2 corner_size = float2(cornerRadius / ratio, cornerRadius);
    
    if (progress <= 0.0) {
        // 0.0: start with the base frame always
        return getFromColor(p, fromTexture, ratio, _fromR);
    } else if (progress < 0.1) {
        // 0.0-0.1: zoom out and add rounded corners
        a = progress / 0.1;
        return simple_sample_with_corners_from(p, corner_size * a, a, zoom, ratio, fromTexture, _fromR);
    } else if (progress < 0.48) {
        // 0.1-0.48: Split original image apart
        a = (progress - 0.1)/0.38;
        return get_cross_rotated(p3, a, corner_size, ratio, zoom, fromTexture, _fromR);
    } else if (progress < 0.9) {
        // 0.48-0.52: black
        // 0.52 - 0.9: unmask new image
        return get_cross_masked(p3, (progress - 0.52)/0.38, corner_size, ratio, zoom, toTexture, _toR);
    } else if (progress < 1.0) {
        // zoom out and add rounded corners
        a = (1.0 - progress) / 0.1;
        return simple_sample_with_corners_to(p, corner_size * a, a, zoom, ratio, toTexture, _toR);
    } else {
        // 1.0 end with base frame
        return getToColor(p, toTexture, ratio, _toR);
    }
}
