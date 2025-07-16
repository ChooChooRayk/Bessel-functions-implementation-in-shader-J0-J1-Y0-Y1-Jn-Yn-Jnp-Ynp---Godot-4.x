shader_type canvas_item;

group_uniforms Mie_params;
uniform float wvlth1_nm :hint_range(300, 850, 0.1) = 632.; // [nm]
uniform float rad_nw   :hint_range( 40, 500, 1) = 100.; // [nm]
uniform int coeff_sum :hint_range(0, 20, 1) = 1; // [1]

group_uniforms Aspect_params;
uniform float agl_offset  :hint_range(-3.14, 3.14, 0.01)= 0.0;
uniform float height_span :hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float height_trans:hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float alpha_res   :hint_range(0.0, 1.0, 0.1) = 0.0;

#include "res://shaders/mie_scattering_cylinder/mie_functions.gdshaderinc"
#include "res://shaders/tools/colorimetry.gdshaderinc"

void fragment() {
	float coord_agl = (UV.x-0.5)*2.0*PI + agl_offset;
	// ---
	float n_idx = n_idx_3CSiC_shaffer1971(wvlth1_nm);
	float irr1  = mie_radial_scattered_intensity_SglPW_para(coord_agl, wvlth1_nm, rad_nw, n_idx, vec2(1.0,0.0), coeff_sum);
	// ---
	vec3 clr1 = wavelength_to_rgb_extended(wvlth1_nm);
	//float alpha = 1.0-dist_to_cntr;
	float mask = irr1 * smoothstep(height_span+height_trans, height_span, abs(UV.y-0.5));
	//mask = step(0.5, mask);
	// ---
	COLOR   = vec4(clr1, 1.0)*mask;
}

//void light() {
	//DIFFUSE_LIGHT = NORMAL * Ir_agl;
	//SPECULAR_LIGHT= wavelength_to_rgb_extended(wvlth1_nm);
//}