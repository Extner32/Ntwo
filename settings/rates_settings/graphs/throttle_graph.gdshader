shader_type canvas_item;

uniform float graph_thickness = 0.01;
uniform float antialias_strength :hint_range(0.0, 1.0, 0.1);
uniform vec4 graph_color: source_color;
uniform vec4 background_color: source_color;


float dst_to_line(vec2 p, vec2 a, vec2 b) {
	// p is the sample point, a and b are the start and end of the line
	float numerator = (b.x-a.x)*(p.y-a.y)-(b.y-a.y)*(p.x-a.x);

	float c = (b.x-a.x);
	float d = (b.y-a.y);
	float denominator = sqrt(c*c + d*d);
	return abs(numerator)/denominator;
}

float antialias(float x, float sharpness) {
	return smoothstep(0.5*sharpness, 1.0-0.5*sharpness, x);
}

void fragment() {
	float dx = 0.01;
	
	vec2 uv_centered = (UV-vec2(0.5, 0.5))*2.0;

	float y1 = rates_function(uv_centered.x);
	float y2 = rates_function(uv_centered.x+dx);
	
	float dst = dst_to_line(UV, vec2(UV.x, y1-graph_thickness/2.0), vec2(UV.x+dx, y2-graph_thickness/2.0));
	
	//COLOR.r = aspect_ratio;
	
	COLOR = mix(graph_color, background_color, antialias(dst/graph_thickness, 1.0-antialias_strength)); 


}