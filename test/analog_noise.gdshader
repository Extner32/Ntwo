shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap, repeat_disable;

uniform float contrast: hint_range(0.0, 3.0) = 1.0;
uniform float brightness: hint_range(-1.0, 1.0) = 0.0;
uniform float saturation: hint_range(0.0, 5.0) = 1.0;
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float noise_strength: hint_range(0.0, 1.0);

//Blur Sharp
uniform float blur_sharp: hint_range(-10.0, 10.0, 0.1) = 0.0;
uniform float pixel: hint_range(1.0, 5.0, 1.0) = 1.0;


float v2random(vec2 uv) {
	return texture(noise_texture, mod(uv, vec2(1.0))).x;
}

vec3 get_noise(vec2 uv) {
	vec2 noise_uv = uv*0.8+v2random(vec2(TIME*0.1));
	vec3 noise_color = texture(noise_texture, noise_uv).rgb;
	
	return noise_color;
}

void fragment() {
	vec2 garbled_uv = SCREEN_UV+get_noise(SCREEN_UV).xy*0.01;
	vec3 screen_color = texture(screen_texture, garbled_uv).rgb;
	screen_color = screen_color + get_noise(SCREEN_UV) * noise_strength;
	

	vec2 coord = (1.0 / FRAGCOORD.xy) * garbled_uv;
	// Screen Sample
	//Blur Sharp Sample
	vec3 north = texture(screen_texture, garbled_uv + (coord * (vec2(0.0, pixel)))).rgb;
	vec3 south = texture(screen_texture, garbled_uv + (coord * (vec2(0.0, -pixel)))).rgb;
	vec3 east = texture(screen_texture, garbled_uv + (coord * (vec2(pixel, 0.0)))).rgb;
	vec3 west = texture(screen_texture, garbled_uv + (coord * (vec2(-pixel,0.0)))).rgb;
	//Combined Samples
	vec3 combine_sample = ((north + south + east + west) / 4.0) * 0.7;
	vec3 blur_screen = clamp((screen_color * 0.3) + combine_sample, 0.0, 1.0);
	//Final COLOR
	vec3 mix_blur_sharp = mix(screen_color, blur_screen, blur_sharp);
	
	vec3 color_corrected = contrast*(mix_blur_sharp-vec3(0.5))+vec3(0.5)+brightness;
	float luminance = dot(color_corrected, vec3(0.299, 0.587, 0.114));
	color_corrected = clamp(luminance+(color_corrected-luminance)*saturation, vec3(0.0), vec3(1.0));
	
	

	
	COLOR.rgb = color_corrected;
}

// Adapted from YouTube tutorial:
// Ben Cloward - Blur and Sharpen Filter - Shader Graph Basics - Episode 51

