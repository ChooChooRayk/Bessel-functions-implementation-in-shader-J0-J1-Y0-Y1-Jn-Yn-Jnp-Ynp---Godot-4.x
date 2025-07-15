shader_type canvas_item;

uniform float wvlth_nm :hint_range(450, 850, 1) = 632.;
uniform float rad_nw   :hint_range(40, 1000, 1) = 100.;

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
	float wvlth = wvlth_nm*1.0e-9;
	float n_idx = n_idx_3CSiC_shaffer1971(wvlth_nm);
	//float Ir = mie_radial_scattered_intensity_SglPW_para(r_phi.y, wvlth, rad_nw*1.0e-9, n_idx, vec2(1.0,0.0), 1);
}
