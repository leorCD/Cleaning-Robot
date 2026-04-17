shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.rgb = texture(TEXTURE, UV).rgb;
	
	// we need (1 - texture) bc the texture will be black by default
	// we're just changing opacity
	float mask = texture(mask_texture, UV).r;
	mask = step(1.0, mask);
	COLOR.a = 1.0 - mask;
}