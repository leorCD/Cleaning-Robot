shader_type canvas_item;

uniform vec4 newColor : source_color; // color to replace with
uniform vec4 targetColor : source_color; // color you wanna replace
uniform float roughness : hint_range(0.0, 1.0, 0.01) = 0.01; // how close the color match can be

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 originalColor = texture(TEXTURE, UV);
	
	float dist = distance(originalColor.rgb, targetColor.rgb);
	
	if (dist < roughness){ // if within range, replace color with new color
		COLOR = vec4(newColor.rgb, originalColor.a);
	} else{ // otherwise, just leave that pixel
		COLOR = originalColor;
	}
	
}
