#version 460 core
#include <flutter/runtime_effect.glsl>


layout(location=0) uniform vec2 iResolution;
layout(location=2) uniform float iTime;
// colors
layout(location=3) uniform vec3 colors[2];
// sizes
layout(location=9) uniform float sizes[2];
// other
layout(location=11) uniform float zoom;
layout(location=12) uniform float speed;
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
    vec2 pos = polarCoord(fragCoord.xy, iResolution.xy);

    // This logic could be taken out of the shader and be marginally faster
    // but I don't feel like programming that logic right now
    // it'll probably be fine
    float sizeSum = 0.;
    for (int i = 0; i < sizes.length(); ++i) {
        sizeSum += sizes[i];
    }
    float scaledSizes[sizes.length()];
    for (int i = 0; i < sizes.length(); ++i) {
        scaledSizes[i] = sizes[i] / sizeSum;
    }

    // How wide a pair of rings are.
    // Dividing sizeSum by the length to keep zoom based on [1.,1.]
    float ringsWidth = 1. / zoom;
    // Wrap around until we've got a position within [0.0, twoRingWidth)
    float ringPos = mod(pos.x + iTime * speed, ringsWidth);
    // Divide by twoRingWidth to get back into [0.0, 1.0]
    if (ringPos / ringsWidth < scaledSizes[0]){
        fragColor = vec4(colors[0], 1.);
    }
    else{
        fragColor = vec4(colors[1], 1.);
    }
}
