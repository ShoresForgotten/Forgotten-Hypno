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
layout(location=8)uniform float angle;
layout(location=9)uniform float zoom;
out vec4 fragColor;

#define M_PI 3.1415926538
#define EULER 2.7182818284590452353602874713526624977572

// https://stackoverflow.com/a/32353829

vec2 polarCoord(vec2 coord)
{
    vec2 uv = (coord - iResolution.xy * .5); // get vector to centre
    uv = uv/min(iResolution.x, iResolution.y); // Normalize to screen
    float dist = distance(uv, vec2(.0));
    float angle = atan(uv.y, uv.x); // get angle
    angle = angle/(radians(180)*2.0) + 0.5; // angle is between [-Pi,Pi], so get it into [.0,1.0]
    return vec2(dist, angle);
}

float logSpiral(float a, float k, float phi) // returns r for the given angle phi (and constants)
{
    return a * pow(EULER, (k * phi));
}
float invLogSpiral(float a, float k, float r) // inverted version of logSpiral, returns phi for given radius r
{
    return (1./k) * log(r/a);
}

void main()
{
    //int arms = 5;
    //float angle = 2.0;
    //float zoom = 0.5;
    vec2 fragCoord = FlutterFragCoord();
    vec2 pos = polarCoord(fragCoord.xy); // get the polar coordinates of the current fragment
    float fragSpiralAngle = invLogSpiral(zoom, angle, pos.x); // get the angle of the spiral that r would be on without offset
    float offsetAngle = fragSpiralAngle + pos.y; // offset the angle by the actual phi of pos
    if (offsetAngle > 1.0)
    {
        offsetAngle -= 1.0;
    }
    int segments = 2 * int(arms) - 1;
    float angleInterval = 1.0 / (2. * arms);
    bool found = false;

    fragColor = vec4(arms, angle, zoom, 1.0);
    /*
    for(int segment = 0; segment <= 99; ++segment) { // I hate you SkSL
        if (offsetAngle >= segment * angleInterval && offsetAngle < (segment +1) * angleInterval)
        {
            if (mod(segment, 2) == 0)
            {
                fragColor = vec4(1.0);
            }
            else
            {
                fragColor = vec4(vec3(0.), 1.);
            }
            break;
        }
        */

        /*
        if (offsetAngle >= i && offsetAngle < i + angleInterval && found == false)
        {
            fragColor = vec4(1.0);
            found = true;
        }
        if (offsetAngle >= i + angleInterval && offsetAngle < i + angleInterval * 2.0 && found == false)
        {
            fragColor = vec4(vec3(0.0), 1.0);
            found = true;
        }
        */
    //}

}