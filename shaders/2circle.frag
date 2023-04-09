#version 460 core
#include <flutter/runtime_effect.glsl>

layout(location=0) uniform vec2 iResolution;
layout(location=2) uniform float iTime;
// colors
layout(location=3) uniform vec3 colorOne;
layout(location=6) uniform vec3 colorTwo;
// other
layout(location=9) uniform float visibleRings;
layout(location=10) uniform float speed;
out vec4 fragColor;

float floatWrap(float x, float wrap) {
    if (x > wrap) {
        return x - floor(x / wrap) * wrap;
    }
    else return x;
}

// https://stackoverflow.com/a/32353829
vec2 polarCoord(vec2 coord, vec2 resolution) {
    vec2 uv = (coord - resolution.xy * .5); // get vector to centre
    uv = uv/min(resolution.x, resolution.y); // Normalize to screen
    float dist = distance(uv, vec2(.0));
    float angle = atan(uv.y, uv.x); // get angle
    angle = angle/(radians(180.)*2.0) + 0.5; // angle is between [-Pi,Pi], so get it into [.0,1.0]
    return vec2(dist, angle);
}
void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 pos = polarCoord(fragCoord.xy, iResolution.xy);

    // How wide a pair of rings are.
    float twoRingWidth = 1. / (visibleRings);
    float ringPos = floatWrap(pos.x + iTime * speed, twoRingWidth);
    if (mod(int(floor((ringPos / twoRingWidth) * 2.)), 2) == 0) {
        fragColor = vec4(colorOne, 1.);
    }
    else{
        fragColor = vec4(colorTwo, 1.);
    }
}
