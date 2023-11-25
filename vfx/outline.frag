// https://www.love2d.org/forums/viewtopic.php?p=221177&sid=d39cedc45854212c979bfcfc8c4aa677#p221177
extern vec2 pixelSize;
extern vec4 outlineColor = vec4(1, 1, 1, 1);
extern float size = 1;
extern float smoothness = 0;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 fc) {
  float a = 0;
  for(float y = -size; y <= size; ++y) {
    for(float x = -size; x <= size; ++x) {
      a += Texel(texture, uv + vec2(x * pixelSize.x, y * pixelSize.y)).a;
    }
  }
  a = color.a * min(1, a / (2 * size * smoothness + 1)) * outlineColor.a;
  vec4 pixel = Texel(texture, uv);

  return mix(vec4(outlineColor.rgb, a), pixel, pixel.a);
}

