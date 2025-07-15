/*
	Colorimetric methods and function to render physically accurate colors.
*/

vec3 wavelength_to_rgb(float _wvlth_nm) {
	/*
    * This converts a given wavelength of light to an
      approximate RGB color value. The wavelength must be given
      in nanometers in the range from 380 nm through 750 nm
      (789 THz through 400 THz).
      Based on code by Dan Bruton
      http://www.physics.sfasu.edu/astro/color/spectra.html
    * Arguments:
        - wavelength : float, ndarray in [nm]
	*/
	vec3 clr = vec3(0.0);
	float gamma = 0.8;
	// ---
	float cond1 = float((380. <  _wvlth_nm) && (_wvlth_nm <= 440.));
	float cond2 = float((440. <  _wvlth_nm) && (_wvlth_nm <= 490.));
	float cond3 = float((490. <  _wvlth_nm) && (_wvlth_nm <= 510.));
	float cond4 = float((510. <  _wvlth_nm) && (_wvlth_nm <= 580.));
	float cond5 = float((580. <  _wvlth_nm) && (_wvlth_nm <= 645.));
	float cond6 = float((645. <  _wvlth_nm) && (_wvlth_nm <= 750.));
	// ---
	float attenuation = 0.0;
	attenuation += cond1 * (0.3 + 0.7 * (_wvlth_nm - 380.) / (440. - 380.));
	//attenuation += cond2 * (0.3 + 0.7 * (_wvlth_nm - 380) / (440 - 380));
	//attenuation += cond3 * (0.3 + 0.7 * (_wvlth_nm - 380) / (440 - 380));
	//attenuation += cond4 * (0.3 + 0.7 * (_wvlth_nm - 380) / (440 - 380));
	//attenuation += cond5 * (0.3 + 0.7 * (_wvlth_nm - 380) / (440 - 380));
	attenuation += cond6 * (0.3 + 0.7 * (750. - _wvlth_nm) / (750. - 645.));
	// ---
	//clr.r += cond1 * pow(((-(_wvlth_nm - 440.) / (440. - 380.)) * attenuation), gamma);
	clr.r += cond2 * 0.0;
	clr.r += cond3 * 0.0;
	//clr.r += cond4 * pow(((_wvlth_nm - 510.) / (580. - 510.)), gamma);
	clr.r += cond4 * ((_wvlth_nm - 510.) / (580. - 510.));
	clr.r += cond5 * 1.0;
	//clr.r += cond6 * pow((1.0 * attenuation), gamma);
	clr.r += cond6 * (1.0 * attenuation);
	// ---
	clr.g += cond1 * 0.0;
	//clr.g += cond2 * pow(((_wvlth_nm - 440.) / (490. - 440.)), gamma);
	clr.g += cond2 * ((_wvlth_nm - 440.) / (490. - 440.));
	clr.g += cond3 * 1.0;
	clr.g += cond4 * 1.0;
	//clr.g += cond5 * pow((-(_wvlth_nm - 645.) / (645. - 580.)), gamma);
	clr.g += cond5 * (-(_wvlth_nm - 645.) / (645. - 580.));
	clr.g += cond6 * 0.0;
	// ---
	//clr.b += cond1 * pow((1.0 * attenuation), gamma);
	clr.b += cond1 * (1.0 * attenuation);
	clr.b += cond2 * 1.0;
	//clr.b += cond3 * pow((-(_wvlth_nm - 510.) / (510. - 490.)), gamma);
	clr.b += cond3 * (-(_wvlth_nm - 510.) / (510. - 490.));
	clr.b += cond4 * 0.0;
	clr.b += cond5 * 0.0;
	clr.b += cond6 * 0.0;
	// ---  --- //
	return clr;
}

vec3 wavelength_to_rgb_extended(float _wvlth_nm) {
	vec3 clr = vec3(0.0);
	// ---
	vec3 clr_uv = vec3(0.75);
	vec3 clr_ir = vec3(0.75);
	float decay_uv = 5.;
	float decay_ir = 8.;
	// ---  --- //
	float conduv= float(_wvlth_nm<=380.);
	float condir= float(750.< _wvlth_nm);
	// ---
	clr  = wavelength_to_rgb(_wvlth_nm);
	clr += conduv * ((wavelength_to_rgb(380.1) - clr_uv)*exp(-decay_uv*(1.-_wvlth_nm/380.)) + clr_uv);
	clr += condir * ((wavelength_to_rgb(749.9) - clr_ir)*exp(-decay_ir*(_wvlth_nm/750.-1.)) + clr_ir);
	// ---  --- //
	return clr;
}