#version 460
#include <flutter/runtime_effect.glsl>

layout(location=0) uniform vec2 size;
layout(location=2) uniform float iTime;
layout(location=3) uniform vec3 colorOne;

out vec4 fragColor;

void main() {
    fragColor = vec4(colorOne, 1.0);
}
