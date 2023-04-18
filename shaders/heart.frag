#version 460 core
#include <flutter/runtime_effect.glsl>

// Resolution and time
layout(location=0)uniform vec2 iResolution;
layout(location=2)uniform float iTime;
// Colors
layout(location=3)uniform vec3 colors[2];
// Other uniforms
layout(location=9)uniform float zoom;
layout(location=10)uniform float speed;
out vec4 fragColor;

// https://stackoverflow.com/a/32353829
vec2 polarCoord(vec2 coord, vec2 resolution) {
    vec2 uv = (coord - resolution.xy * .5); // get vector to centre
    uv = uv/min(resolution.x, resolution.y); // Normalize to screen
    float dist = distance(uv, vec2(.0));
    float angle = atan(uv.y, uv.x); // get angle
    angle = angle/(radians(180.)*2.0) + 0.5; // angle is between [-Pi,Pi], so get it into [.0,1.0]
    return vec2(dist, angle);
}


vec2 polarCoordPi(vec2 coord, vec2 resolution) {
    vec2 uv = (coord - resolution.xy * .5);// get vector to centre
    uv = uv/min(resolution.x, resolution.y);// Normalize to screen
    float dist = distance(uv, vec2(.0));
    float angle = atan(uv.y, uv.x);// get angle
    return vec2(dist, angle);
}
float heart(float theta) {
    // https://mathworld.wolfram.com/HeartCurve.html
    return 2 - 2 * sin(theta) + sin(theta) * (sqrt(abs(cos(theta))) / (sin(theta) + 1.4));
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 rawPos = polarCoordPi(fragCoord.xy, iResolution);// get the polar coordinates of the current fragment

    // Get angle into [0.0, 0.5], symmetric across the y axis.
    // This makes it so we only have to figure out the formula for one half, since a heart is symmetric.
    vec2 pos = vec2(rawPos.x, mod(rawPos.y + 0.25, 1.));
    if (pos.y > 0.5) {
        pos.y = .5 - mod(pos.y, 0.5);
    }

    float heartVar = heart(rawPos.y);
    float aaa = mod(rawPos.x + iTime, heartVar);

    // divide the angle of the current position by the arm interval to get the arm we're on
    if (aaa > 0.5 * heartVar) {
        fragColor = vec4(colors[0], 1.);
    }
    else {
        fragColor = vec4(colors[1], 1.);
    }
}
