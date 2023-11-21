extern sampler2D noise;
extern float strength;

vec4 effect(vec4 color, sampler2D tex,
    vec2 tex_coords, vec2 screen_coords) {
  vec4 pixel = texture2D(tex, tex_coords);
  float n = texture2D(noise, tex_coords).r;
  return vec4(pixel.rgb, mix(0, n * pixel.a * 2.0, strength));
}
