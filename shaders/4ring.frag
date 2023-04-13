#version 460 core
#include <flutter/runtime_effect.glsl>

layout(location=0) uniform vec2 iResolution;
layout(location=2) uniform float iTime;
// colors
layout(location=3) uniform vec3 colors[4];
// other
layout(location=15) uniform float zoom;
layout(location=16) uniform float speed;
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
    vec2 fragCoord = FlutterFragCoord();
    vec2 pos = polarCoord(fragCoord.xy, iResolution.xy);

    // How wide a group of rings is.
    float ringsWidth = 1. / zoom;
    // Wrap around until we've got a position within [0.0, twoRingWidth)
    float ringPos = mod(pos.x + iTime * speed, ringsWidth);
    // Divide by twoRingWidth to get back into [0.0, 1.0]
    float relativeRingPos = ringPos / ringsWidth;
    // I have nightmares about SkSL hunting me down and kneeing me in the groin
    if (relativeRingPos < .25){
        fragColor = vec4(colors[0], 1.);
    }
    else if(relativeRingPos >= .25 && relativeRingPos < .5){
        fragColor = vec4(colors[1], 1.);
    }
    else if(relativeRingPos >= .5 && relativeRingPos < .75) {
        fragColor = vec4(colors[2], 1.);
    }
    else {
        fragColor = vec4(colors[3], 1.);
    }
    // if SkSL allowed for non-constant index array access I could divide relativeRingPos by visibleRings
    // And then access the color at the resulting number (truncated to int)
    // This would theoretically allow for an arbitrary amount of colors between [1, (MAX_UNIFORM_LOCATIONS - 5) / 3]
    // and that would be pretty cool
}
