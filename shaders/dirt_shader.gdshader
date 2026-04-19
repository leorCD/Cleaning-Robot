shader_type canvas_item;

uniform sampler2D mask_texture : hint_default_black; // object mask (make sure parts u wanna draw on are black and everythig else is white)
uniform sampler2D brush_texture : hint_default_black; // subviewport

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(TEXTURE, UV);
	
	float base_mask = texture(mask_texture, UV).r;
	float brush_mask = texture(brush_texture, UV).r;
	
	float mask = step(0.5, max(0.0, base_mask + brush_mask));
	COLOR.rgb = tex.rgb;
	COLOR.a = tex.a * (1.0 - mask);
}