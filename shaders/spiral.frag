#version 460 core
#include <flutter/runtime_effect.glsl>

// Resolution and time
layout(location=0) uniform vec2 iResolution;
layout(location=2) uniform float iTime;
// Colors
layout(location=3) uniform vec3 colors[2];
// Sizes
layout(location=9) uniform float sizes[2];
// Other uniforms
layout(location=11) uniform float arms;
layout(location=12) uniform float zoom;
layout(location=13) uniform float speed;
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

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 pos = polarCoord(fragCoord.xy, iResolution);// get the polar coordinates of the current fragment

    float sizeSum = 0.;
    for (int i = 0; i < sizes.length(); ++i) {
        sizeSum += sizes[i];
    }
    float scaledSizes[sizes.length()];
    for (int i = 0; i < sizes.length(); ++i) {
        scaledSizes[i] = sizes[i] / sizeSum;
    }

    float spiral = mod(pos.y + iTime * speed * (1./60.) + pos.x * zoom, 1.0 );
    float armInterval = 1.0 / arms;
    // divide the angle of the current position by the arm interval to get the arm we're on
    if (mod(abs(spiral / armInterval), 1.0) > scaledSizes[0]) {
        fragColor = vec4(colors[0], 1.);
    }
    else {
        fragColor = vec4(colors[1], 1.);
    }
}