#version 460 core
#include <flutter/runtime_effect.glsl>

// Resolution and time
layout(location=0)uniform vec2 iResolution;
layout(location=2)uniform float iTime;
// Colors
layout(location=3)uniform vec3 colorOne;
layout(location=6)uniform vec3 colorTwo;
// Other uniforms
layout(location=7)uniform float arms;
layout(location=8)uniform float zoom;
layout(location=9)uniform float speed;
out vec4 fragColor;

// https://stackoverflow.com/a/32353829

float floatWrap(float x, float wrap) {
    if (x > wrap) {
        return x - floor(x / wrap) * wrap;
    }
    else return x;
}

vec2 polarCoord(vec2 coord) {
    vec2 uv = (coord - iResolution.xy * .5); // get vector to centre
    uv = uv/min(iResolution.x, iResolution.y); // Normalize to screen
    float dist = distance(uv, vec2(.0));
    float angle = atan(uv.y, uv.x); // get angle
    angle = angle/(radians(180.)*2.0) + 0.5; // angle is between [-Pi,Pi], so get it into [.0,1.0]
    return vec2(dist, angle);
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 pos = polarCoord(fragCoord.xy);// get the polar coordinates of the current fragment

    float spiral = floatWrap(pos.y + iTime * speed * (1./60.) + pos.x * zoom, 1.0 );
    float armInterval = 1.0 / (arms * 2.);
    // divide the angle of the current position by the arm interval to get the arm we're on
    int activeArm = int(floor(spiral / armInterval));
    if (mod(activeArm, 2) == 0) { // evens are colorOne, odds are colorTwo
        fragColor = vec4(colorOne, 1.);
    }
    else {
        fragColor = vec4(colorTwo, 1.);
    }
}