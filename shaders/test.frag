#version 440

layout(location=3) uniform float red;
layout(location=4) uniform float green;
layout(location=5) uniform float blue;

out vec4 fragColor;

void main() {
    fragColor = vec4(red, green, blue, 1.0);
}
