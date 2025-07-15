shader_type spatial;
render_mode depth_prepass_alpha;

uniform float level : hint_range(0.0, 1.0) = 1.0;
uniform float emission_intensity : hint_range(0.0, 1.0);

uniform vec3 fresnel_color : source_color;
uniform float fresnel_intensity : hint_range(0.0, 10.0);
uniform float fresnel_power : hint_range(1.0, 10.0);

uniform vec3 mtrl_color :source_color = vec3(0.0);
uniform float residual_clr_int :hint_range(0.0, 1.0, 0.1);
uniform float residual_transparency :hint_range(0.0, 1.0, 0.1);
uniform float alpha_mltiplyer :hint_range(0.0, 1.0, 0.1)= 1.0;

#include "res://shaders/tools/colorimetry.gdshaderinc"
uniform float laser_wvlth :hint_range(300., 850., 0.1)= 632.; // [nm]

void fragment()
{
	vec3 laser_clr = wavelength_to_rgb_extended(laser_wvlth);
	//laser_clr = vec3(1.,0.,0.);
	// ---
	float dir = 1.0 - clamp(dot(normalize(NORMAL), normalize(VIEW)), 0.0, 1.0);
	float fresnel_amount = pow(dir, fresnel_power) * fresnel_intensity;
	//vec3 fresnel = fresnel_color * fresnel_amount;
	vec3 fresnel = laser_clr * fresnel_amount;
	// ---
	float alpha = clamp(fresnel_amount * level + residual_transparency, 0.0, 1.0);
	// ---
	ALBEDO = fresnel + mtrl_color*residual_clr_int;// + rim;
	EMISSION = fresnel * emission_intensity * level;
	ALPHA = alpha * alpha_mltiplyer;
}

void light() {
	DIFFUSE_LIGHT = vec3(1,1,1);
}