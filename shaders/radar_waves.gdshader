shader_type canvas_item;

uniform float DisappearHeight : hint_range(-0.1, 1.1) = 1.0;

void fragment() {
	float original_alpha = COLOR.a;
	//if (UV.y < DisappearHeight) {
		//COLOR = vec4(COLOR.rgb, 0.0);
	//}
	COLOR.a = 0.0;
	if (UV.y-0.1 < DisappearHeight && UV.y+0.1 > DisappearHeight) {
		COLOR = vec4(COLOR.rgb, original_alpha);
	}
}
