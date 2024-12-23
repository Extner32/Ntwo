shader_type canvas_item;

uniform float max_rate;
uniform float center_rate;
uniform float expo;

uniform float graph_thickness = 0.01;
uniform vec4 graph_color: source_color;
uniform vec4 background_color: source_color;

float rates_function(float x) {
	//x is in the range [-1, 1]
	//you can see a desmos graph here:
	//https://www.desmos.com/calculator/5hlbr3utht
	float expo_factor = x*(pow(x, 5) * expo + x*(1.0-expo));
	//this is multiplied by sign(x) so it also works for x < 0
	return (center_rate*x)+((max_rate-center_rate)*expo_factor) * sign(x);
}

float dst_to_line(vec2 p, vec2 a, vec2 b) {
	// p is the sample point, a and b are the start and end of the line
	float numerator = (b.x-a.x)*(p.y-a.y)-(b.y-a.y)*(p.x-a.x);
	
	float c = (b.x-a.x);
	float d = (b.y-a.y);
	float denominator = sqrt(c*c + d*d);
	return abs(numerator)/denominator;
}

void fragment() {
	//float y = 1.0 - (rates_function(UV.x)/max_rate);
	//float difference = abs(UV.y-y);
	//if (difference < graph_thickness) {
		//COLOR = graph_color;
	//}
	//else {
		//COLOR = background_color;
	//}
	
	float dx = 0.01;
	
	float y1 = 1.0 - (rates_function(UV.x)/max_rate);
	float y2 = 1.0 - (rates_function(UV.x+dx)/max_rate);
	float dst = dst_to_line(UV, vec2(UV.x, y1), vec2(UV.x+dx, y2));
	//float dst_sq = dst_sq_to_line(UV, vec2(0, 0.5), vec2(1.0, 0.5));
	if (dst <= (graph_thickness/2.0)) {
		COLOR = graph_color;
	}
	else {
		COLOR = background_color;
	}
	
	
}
