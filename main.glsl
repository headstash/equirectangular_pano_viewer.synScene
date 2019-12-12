// https://www.interactiveshaderformat.com/sketches/1269
// Author: @nikharron<https://www.interactiveshaderformat.com/u/nikharron>

// Ported from "No Geometry 360 Video" by KylBlz: https://www.shadertoy.com/view/Ml33z2
// Test image from Flickr by raneko at http://flickr.com/photos/24926669@N07/6475787765
// Via WikiCommons, licensed cc-by-2.0.

vec3 iResolution = vec3(RENDERSIZE, 1.);

#define PI 3.14159265

//tools
vec3 rotateXY(vec3 p, vec2 angle) {
    vec2 c = cos(angle), s = sin(angle);
    p = vec3(p.x, c.x*p.y + s.x*p.z, -s.x*p.y + c.x*p.z);
    return vec3(c.y*p.x + s.y*p.z, p.y, -s.y*p.x + c.y*p.z);
}

void mainImage( out vec4 fC, in vec2 fX ) {

	iResolution.x = iResolution.x * (iResolution.y/iResolution.x);

	float DISTORT = DISTORT*2.0*PI+.0001;

    //place 0,0 in center from -1 to 1 ndc
    vec2 uv = fX.xy/iResolution.xy*2.-1.;

    // Correct Horizontal Mirroring
    uv.x = uv.x*-1.+(PI*textureXY.x-1.);
    uv.y = uv.y+(PI*textureXY.y-1.);

    vec2 CAMERA = vec2 (lookXY.x*2.-1.,lookXY.y*2.-1.);
    CAMERA *= iResolution.xy;

    //to spherical
    vec3 camDir = normalize(vec3(uv.xy, 1. + (ZOOM*2.0-1.) - (uv.x/DISTORT*uv.x/DISTORT) - (uv.y/DISTORT*uv.y/DISTORT)));

    //camRot is angle vec in rad
    vec3 camRot = vec3(CAMERA.yx * PI / iResolution.xy, 0.);

    //rotate
    vec3 rd = (rotateXY(camDir, camRot.xy));

    //radial azmuth polar
    vec2 RadAzPol = vec2(atan(rd.z, rd.x) + PI, acos(-rd.y)) / vec2(2.0 * PI, PI);

    //this is not a radial texture but whatever
    fC = IMG_NORM_PIXEL(syn_UserImage, fract(RadAzPol * vec2(1.0, 1.0)));
}


vec4 renderMain() {
 	vec4 out_FragColor = vec4(0.0);

    mainImage(out_FragColor, _xy.xy);

return out_FragColor;
 }
