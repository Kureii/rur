shader_type spatial;

uniform sampler2D base_color: hint_default_black;
uniform sampler2D normal_map: hint_normal;
uniform sampler2D arm_map: source_color;
uniform sampler2D mask: source_color;
uniform float saturation: hint_range(0.0, 2.0, 0.01);
uniform vec3 mask_color: source_color;

vec3 saturate_color(vec3 color) {
	float luminace = dot(color, vec3(0.2126,0.7152,0.0722));
	return mix(vec3(luminace), color, saturation);
}

void fragment() {
	vec3 base_texture = texture(base_color, UV).rgb;
	vec3 normal_texture = texture(normal_map, UV).rgb;
	vec3 arm_texture = texture(arm_map, UV).rgb;
	float mask_texture = texture(mask, UV).g;
	base_texture = mix(base_texture, mask_color, mask_texture);
	
	ALBEDO = saturate_color(base_texture);
	NORMAL_MAP = normal_texture;
	ROUGHNESS = arm_texture.g;
	METALLIC = arm_texture.b;
	AO = arm_texture.r;
}

