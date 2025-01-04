// https://www.shadertoy.com/view/MdffD7
// Fork of FMS_Cat's VCR distortion shader

shader_type canvas_item;

// TODO: Add uniforms for tape crease discoloration and image jiggle

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap, repeat_disable;

uniform vec2 vhs_resolution = vec2(320.0, 240.0);



uniform float noise_intensity: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform sampler2D noise_texture: filter_nearest, repeat_enable;

uniform float aberration_strength = 1.0;

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec4 offset_color1 = texture(screen_texture, SCREEN_UV+aberration_strength);
	vec4 offset_color2 = texture(screen_texture, SCREEN_UV-aberration_strength);
	COLOR = 
}