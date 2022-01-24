#version 400

struct Light
{
    vec4 position;
    vec4 color;

    float radius;
};


in vec2 uv;
out vec4 outputColor;

uniform sampler2D gpositionsTex;
uniform sampler2D gnormalsTex;
uniform sampler2D gdiffuseColTex;
uniform Light uLight;
uniform int ScreenWidth;
uniform int ScreenHeight;

void main()
{
  vec2 cur_uv = vec2(gl_FragCoord.x / ScreenWidth, gl_FragCoord.y / ScreenHeight);

  vec3 pos = texture(gpositionsTex, cur_uv).rgb;

  float D = distance(uLight.position.xyz, pos);
  vec3 N = texture(gnormalsTex, cur_uv).rgb;
  vec3 L = normalize(uLight.position.xyz - pos);
  vec3 V = normalize(-pos);
  vec3 R = normalize(2 * (dot(N , L) * N) - L);
  vec4 diffuse = vec4(texture(gdiffuseColTex, cur_uv).rgb ,1) * max(0, dot(N, L));
  float specular_f = texture(gdiffuseColTex, cur_uv).a;
  vec4 specular = vec4(specular_f, specular_f, specular_f, 1) * pow(max(dot(R, V), 0), 1);//texture(gnormalsTex, uv).a);
  float Att = 1 - min(1, D / uLight.radius);

  //Light equation:
  outputColor = uLight.color * Att * (diffuse + specular);

}