shader_type canvas_item;

uniform float wvlth_nm :hint_range(450, 850, 1) = 632.; // [nm]
uniform float rad_nw   :hint_range( 40, 500, 1) = 100.; // [nm]
uniform int coeff_sum :hint_range(0, 20, 1) = 1; // [1]
//uniform int _m0 = 0;
//uniform int _l0 = 0;
uniform float linewidth :hint_range(0.0, 1.0, 0.001) = 0.1;
uniform float coeff_mult:hint_range(0.0, 100.0, 0.1) = 1.0;
uniform sampler2D clr_map;
//uniform sampler3D mesh;


//#include "res://shaders/bessel/complex_math.gdshaderinc"
//#include "res://shaders/mie_scattering_cylinder/mie_functions.gdshaderinc"


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
	vec2 uv_centered = (UV-0.5)*2.0;
	//vec2 r_phi  = cx_to_polar(uv_centered);
	float uv_rad = length(uv_centered);
	float uv_agl = atan(uv_centered.y, uv_centered.x);
	float n_idx = n_idx_3CSiC_shaffer1971(wvlth_nm);
	// ---
	float irr = 1.0;
	//irr *= mie_radial_scattered_intensity_SglPW_para(uv_agl, wvlth_nm, rad_nw, n_idx, vec2(1.0,0.0), coeff_sum);
	//irr *= cos(float(_m0)*uv_agl)*cos(float(_l0)*uv_agl);
	// ---  --- //
	float line = uv_rad - abs(irr)*coeff_mult;
	float var_1d = clamp(line, 0.0, 1.0);//step(linewidth, abs(line));
	//float var_1d = 1.0;
	// ---
	vec4 clr = texture(clr_map, vec2(var_1d,0.0));
	COLOR = clr;
}
