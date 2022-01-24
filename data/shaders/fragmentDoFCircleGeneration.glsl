#version 400

in vec2 uv;
out vec4 outputColor;

uniform sampler2D gdiffuseColTex;
uniform sampler2D gDepthTex;
uniform float DiameterOfAperture;
uniform float FocalLength;
uniform float FocalPlaneDist;


void main()
{

  outputColor.xyz = texture(gdiffuseColTex, uv).rgb;

  float cur_depth = texture(gDepthTex, uv).r;

  float r = abs(DiameterOfAperture * (FocalLength * (FocalPlaneDist - cur_depth)/ cur_depth * (FocalPlaneDist - FocalLength)));

  outputColor.w = r;

}