shader_type canvas_item;

uniform float wvlth_nm :hint_range(450, 850, 1) = 632.; // [nm]
uniform float rad_nw   :hint_range( 40, 500, 1) = 100.; // [nm]
uniform sampler2D clr_map;
uniform sampler3D mesh;


#include "res://shaders/bessel/complex_math.gdshaderinc"
#include "res://shaders/mie_scattering_cylinder/mie_functions.gdshaderinc"


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

void fragment() {
	vec2 uv_centered = UV-0.5;
	vec2 r_phi = cx_to_polar(uv_centered);
	// ---
	float n_idx = n_idx_3CSiC_shaffer1971(wvlth_nm);
	//
	//vec2 mie_coeff_as = cx_mul(as_m(m0, k0, n_idx, Rnw) , cx_conj( as_m(l0, k0, n_idx, Rnw))); //as_m(0, 1.0, n_idx, 2.0*PI*rad_nw/wvlth_nm);
	//vec2 mie_coeff_as = cx_mul(as_m(0, 1.0, n_idx, 2.*PI*rad_nw/wvlth_nm) , cx_conj( as_m(1, 1.0, n_idx, 2.*PI*rad_nw/wvlth_nm))); //as_m(0, 1.0, n_idx, 2.0*PI*rad_nw/wvlth_nm);
	//vec2 mie_coeff_as = cx_conj(as_m(1, 1.0, n_idx, 2.*PI*rad_nw/wvlth_nm));
	//float irr = mie_radial_scattered_intensity_SglPW_para(r_phi.y, wvlth_nm, rad_nw, n_idx, vec2(1.0,0.0), 1);
	//float irr = mie_radial_scattered_intensity_SglPW_para(r_phi.y, wvlth_nm, rad_nw, n_idx, vec2(1.0,0.0), 1);
	// ---  --- //
	float var_1d = 1.0;
	vec4 clr = texture(clr_map, vec2(var_1d,0.0));
	COLOR = clr;
}
