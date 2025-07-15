shader_type spatial;

group_uniforms Mie_params;
uniform float wvlth1_nm :hint_range(300, 850, 0.1) = 632.; // [nm]
uniform float rad_nw   :hint_range( 40, 500, 1) = 100.; // [nm]
uniform int coeff_sum :hint_range(0, 20, 1) = 1; // [1]

group_uniforms Aspect_params;
uniform float mesh_height = 1.0;
uniform float coeff_mult:hint_range(0.0, 10.0, 0.01) = 0.3;
uniform float rad_offset :hint_range(0.0, 1.0, 0.01)= 0.1;
uniform float alpha_decay :hint_range(0.0, 20.0, 0.1)= 1.0;
uniform float glow_enrg :hint_range(0.0, 10.0, 0.1)= 1.0;

#include "res://shaders/mie_scattering_cylinder/mie_functions.gdshaderinc"
#include "res://shaders/tools/colorimetry.gdshaderinc"

float n_idx_3CSiC_shaffer1971(float wvl_nm) {
	/*
    * Compute the effective refractive index of bulk 3C-SiC at a given
      wavelength.
    * Source : https://refractiveindex.info/?shelf=main&book=SiC&page=Shaffer
               Shaffer 1971: β-SiC
    * Arguments:
        - wvl_nm : float, considered wavelength in vacuum in [nm]
    */
    float a = 2.5538;
    float b = 3.42 * 10000.;
	// ---
    return a + b/pow(wvl_nm,2);
}

varying float dist_to_cntr;

void vertex() {
	//pos = POSITION;
	vec2 coord_xz = VERTEX.xz;
	float height  = VERTEX.y / mesh_height;
	float coord_agl = atan(coord_xz.y, coord_xz.x);
	// ---
	float n_idx = n_idx_3CSiC_shaffer1971(wvlth1_nm);
	float irr1 = mie_radial_scattered_intensity_SglPW_para(coord_agl, wvlth1_nm, rad_nw, n_idx, vec2(1.0,0.0), coeff_sum);
	// ---
	dist_to_cntr = length(coord_xz);
	VERTEX.z = (rad_offset + abs(irr1) *coeff_mult * cos(PI*height)) * sin(coord_agl);
	VERTEX.x = (rad_offset + abs(irr1) *coeff_mult * cos(PI*height)) * cos(coord_agl);
}

void fragment() {
	vec3 clr1 = wavelength_to_rgb_extended(wvlth1_nm);
	//float alpha = 1.0-dist_to_cntr;
	float alpha = exp(-alpha_decay * dist_to_cntr)-exp(-alpha_decay);
	// ---
	ALPHA = alpha;
	ALBEDO   = clr1;
	EMISSION = clr1 * glow_enrg;
}
