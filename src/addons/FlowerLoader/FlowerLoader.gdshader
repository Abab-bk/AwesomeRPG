shader_type canvas_item;

uniform vec2 vertex_scale = vec2(1);
uniform float alpha_dissolve_range : hint_range(0, 2) = 1.0;
uniform bool scale_vertex_by_alpha = false;
uniform bool keep_color_during_dissolve = false;
uniform float intensity : hint_range(-1, 1) = 0.5;
uniform int base_uv_mode : hint_range(0, 2, 1) = 0;
uniform int noise_uv_mode : hint_range(0, 2, 1) = 0;
uniform vec4 base_uv_scale_pan = vec4(1, 1, 0, 0);
uniform vec4 noise_uv_scale_pan = vec4(1, 1, 0, 0);
uniform sampler2D color_gradient : source_color, repeat_disable;
uniform sampler2D noise_texture : hint_default_black, repeat_enable;

varying vec4 MODULATE;

vec2 uv_func(vec2 uv, vec2 scale, vec2 pan, int mode) {
	if (mode == 0) {
		return vec2((uv * scale) + (scale * pan * TIME));
	}
	else if (mode == 1) {
		float rotation = pan.x * length(scale) * TIME * TAU;
		return vec2(cos(rotation) * (uv.x - 0.5) + sin(rotation) * (uv.y - 0.5) + 0.5, cos(rotation) * (uv.y - 0.5) - sin(rotation) * (uv.x - 0.5) + 0.5);
	}
	else if (mode == 2) {
		vec2 dir = uv - vec2(0.5);
		float radius = length(dir) * 2.0;
		float angle = atan(dir.y, dir.x) * 1.0 / TAU;
		return mod(vec2(radius * scale.x, angle * float(scale.y)), 1.0) + (scale * pan * TIME);
	}
	return vec2(uv);
}

void vertex() {
	MODULATE = COLOR;
	VERTEX *= vertex_scale;
	if (scale_vertex_by_alpha) VERTEX *= MODULATE.a;
}

void fragment() {
	vec2 base_uv = uv_func(UV, base_uv_scale_pan.xy, base_uv_scale_pan.zw, base_uv_mode);
	vec2 noise_uv = uv_func(UV, noise_uv_scale_pan.xy, noise_uv_scale_pan.zw, noise_uv_mode);
	float base = texture(TEXTURE, base_uv).r;
	float noise = texture(noise_texture, noise_uv).r;
	float gradient_uv = base + intensity * (noise - 0.5);
	if (!keep_color_during_dissolve) gradient_uv -= (1.0 - MODULATE.a) * alpha_dissolve_range;
	COLOR = texture(color_gradient, vec2(clamp(gradient_uv, 0.0, 1.0)));
	COLOR.rgb *= MODULATE.rgb;
	if (keep_color_during_dissolve) COLOR.a = texture(color_gradient, vec2(clamp(gradient_uv - (1.0 - MODULATE.a) * alpha_dissolve_range, 0.0, 1.0))).a;
}