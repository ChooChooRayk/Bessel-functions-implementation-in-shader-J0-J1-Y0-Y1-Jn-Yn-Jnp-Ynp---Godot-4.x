shader_type spatial;

uniform float laser_wvlth :hint_range(350., 850., 0.1)= 632.;
uniform float glow_enrg   :hint_range(0.0, 10.0, 0.1)=1.0;
uniform float alpha_decay :hint_range(0.0, 10.0, 0.1)= 1.0;
uniform sampler2D txtr :repeat_enable;
uniform float txtr_speed :hint_range(0.0, 10.0, 0.01)=0.1;
uniform vec2 stretch_ratio = vec2(1.0);

#include "res://shaders/tools/colorimetry.gdshaderinc"

varying float dist_to_cntr;

void vertex() {
	dist_to_cntr = length(VERTEX.xz);
}

void fragment() {
	vec3 clr1   = wavelength_to_rgb_extended(laser_wvlth);
	float alpha = exp(-alpha_decay * dist_to_cntr)-exp(-alpha_decay);
	float mask  = texture(txtr, UV*stretch_ratio *10. + vec2(0.0, 1.0)*TIME*txtr_speed).x;
	// ---
	ALPHA    = alpha* mask;
	ALBEDO   = clr1 * mask;
	EMISSION = clr1 * glow_enrg;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
