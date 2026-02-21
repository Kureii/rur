shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;
uniform vec4 camera_color : source_color = vec4(0.8, 0.2, 0.0, 0.6);
uniform vec4 intersect_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float intersect_width : hint_range(0.0, 2.0) = 0.3;

varying float world_y;

void vertex() {
    world_y = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}


void fragment() {
	// hloubka scény z depth bufferu
	float raw_depth = texture(depth_texture, SCREEN_UV).r;
	vec4 scene_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, raw_depth, 1.0);
	scene_pos.xyz /= scene_pos.w;
	
	// hloubka aktuálního fragmentu
	vec4 frag_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, FRAGCOORD.z, 1.0);
	frag_pos.xyz /= frag_pos.w;
	
	// rozdíl = jak blízko je průnik
	float diff = abs(scene_pos.z - frag_pos.z);
	
	float intersect = 1.0 - smoothstep(0.0, intersect_width, diff);
	
	ALBEDO = mix(camera_color.rgb, intersect_color.rgb, intersect);//vec3(intersect * clamp(world_y * 0.25 + 0.5,0.0,1.0));
	ALPHA = mix(camera_color.a, intersect_color.a, intersect * (1.0-clamp(world_y * 0.25 + 0.5,0.0,1.0)));
	ALPHA *= 1.0-clamp(world_y * 0.25 + 0.5,0.0,1.0);
	ALPHA += mix(0.0, intersect_color.a, intersect);
}