shader_type fog;

uniform float wvlth1_nm :hint_range(300, 850, 1) = 632.; // [nm]
uniform float wvlth2_nm :hint_range(300, 850, 1) = 632.; // [nm]
uniform float rad_nw   :hint_range( 40, 500, 1) = 100.; // [nm]
uniform int coeff_sum :hint_range(0, 20, 1) = 1; // [1]
//uniform int _m0 = 0;
//uniform int _l0 = 0;
uniform float linewidth :hint_range(0.0, 1.0, 0.001) = 0.1;
uniform float coeff_mult:hint_range(0.0, 10.0, 0.01) = 1.0;
uniform sampler2D clr_map;
//uniform sampler3D mesh;


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

void fog() {
	vec2 uv_centered = (UVW.xz-0.5)*2.0;
	////vec2 r_phi  = cx_to_polar(uv_centered);
	//float uv_rad = length(uv_centered);
	float uv_rad = length(WORLD_POSITION.xz-OBJECT_POSITION.xz);
	float uv_agl = atan(uv_centered.y, uv_centered.x);
	float n_idx = n_idx_3CSiC_shaffer1971(wvlth1_nm);
	//// ---
	float irr1 = mie_radial_scattered_intensity_SglPW_para(uv_agl, wvlth1_nm, rad_nw, n_idx, vec2(1.0,0.0), coeff_sum);
	//float irr2 = mie_radial_scattered_intensity_SglPW_para(uv_agl, wvlth2_nm, rad_nw, n_idx, vec2(1.0,0.0), coeff_sum);
	//// ---  --- //
	float line1 = uv_rad - abs(irr1)*coeff_mult;
	//float line2 = uv_rad - abs(irr2)*coeff_mult;
	float mask1 = 1.-step(linewidth, line1);
	//float mask2 = 1.-step(linewidth, line2);
	////float var_1d = 1.0;
	//// ---
	vec4 clr1 = vec4(wavelength_to_rgb_extended(wvlth1_nm), 1.);
	//vec4 clr2 = vec4(wavelength_to_rgb_extended(wvlth2_nm), 1.);
	ALBEDO = clr1.rgb;
	DENSITY = mask1*1.;
	DENSITY *= step(0.0, -SDF);
	EMISSION = clr1.rgb*1.;
}
