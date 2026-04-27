shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 1.2;
uniform bool Inverse = true;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV - vec2(0.5, 0.5); // create a clone of the screen and move the origin to the center of the screen
	float dist = length(uv);
	
	float mask = step(dist, radius);
	float MaskAndFadeDirection = Inverse ? 1.0 - mask : mask; // results in 1.0 if true
	
	COLOR = vec4(0.0, 0.0, 0.0, MaskAndFadeDirection);
}


