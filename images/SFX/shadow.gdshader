shader_type canvas_item;
uniform sampler2D distortionTexture;

void fragment() {
	vec2 distort = SCREEN_UV + texture(distortionTexture,UV).r * 0.1;
	vec4 pixelColor = texture(TEXTURE, distort);
	COLOR = pixelColor;
}
