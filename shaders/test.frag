#version 440
#include <flutter/runtime_effect.glsl>

layout(location=0) uniform vec2 size;
layout(location=2) uniform float iTime;
layout(location=3) uniform float red;
layout(location=4) uniform float green;
layout(location=5) uniform float blue;

out vec4 fragColor;

void main() {
    fragColor = vec4(iTime, green, blue, 1.0);
}
