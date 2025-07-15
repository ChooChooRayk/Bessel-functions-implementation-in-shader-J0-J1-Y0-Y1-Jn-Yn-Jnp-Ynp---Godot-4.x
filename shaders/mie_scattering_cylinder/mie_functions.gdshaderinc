/*
	Mie Scattering functions for scattering of a single planewave impinging
	at normal incidence on an infinite cylinder in vaccum, with radius R in [m],
	internal refractive index n_idx [1]. The incident radiation has its wave vector
	in vaccum k0=2*PI/lambda in [m^-1], lambda being the wavelength in [m].
	
	The coefficient for parallel are "a", and "b" for perpendicular incident
	polarisation.
*/

#include "res://shaders/bessel/complex_math.gdshaderinc"
#include "res://shaders/bessel/bessel_functions_J.gdshaderinc"
#include "res://shaders/bessel/bessel_functions_H1H2.gdshaderinc"

vec2 ai_m(int m) {
	return vec2(cos(PI/2.*float(m)), sin(PI/2.*float(m)));
}

vec2 bi_m(int m) {
	return vec2(cos(PI/2.*float(m-1)), sin(PI/2.*float(m-1)));
}

vec2 as_m(int m, float k0, float n_idx, float R) {
	vec2 N = vec2(Bessel_Jvn(m,n_idx*k0*R)*Bessel_Jvpn(m,k0*R) - n_idx*Bessel_Jvpn(m,n_idx*k0*R)*Bessel_Jvn(m,k0*R), 0.0);
	vec2 D = cx_mul(vec2(Bessel_Jvn(m,n_idx*k0*R), 0.0), Bessel_H1vpn(m,k0*R)) - n_idx*cx_mul(vec2(Bessel_Jvpn(m,n_idx*k0*R),0.0), Bessel_H1vn(m,k0*R));
	return -cx_div(N,D);
}

vec2 bs_m(int m, float k0, float n_idx, float R) {
	vec2 N = vec2(n_idx*Bessel_Jvn(m,n_idx*k0*R)*Bessel_Jvpn(m,k0*R) - Bessel_Jvpn(m,n_idx*k0*R)*Bessel_Jvn(m,k0*R), 0.0);
	vec2 D = n_idx*cx_mul(vec2(Bessel_Jvn(m,n_idx*k0*R), 0.0), Bessel_H1vpn(m,k0*R)) - cx_mul(vec2(Bessel_Jvpn(m,n_idx*k0*R),0.0), Bessel_H1vn(m,k0*R));
	return -cx_div(N,D);
}

// ============ Scattered Intensity ============ //

float eps_m0_l0(int m0, int l0) {
	/*
		Symetry factor for the sum over the modes in the asymptotic radial intensity
		calculation.
	*/
    return (8.0/(1.0 + float(m0==l0) + float(0==l0) + float(m0==0) + 4.0*float(m0==l0)*float(0==l0)*float(m0==0)));
}

float mie_radial_scattered_intensity_SglPW_para(float phi, float wvlth, float Rnw, float n_idx, vec2 Ei0, int N_mie) {
	/*
	* Compute the irradiated scattered intensity in a given angle for the far field.
	* It corresponds to the projected Poyting vector of the scattered field along e_r, evaluated in the
	    limiting case of large r, from the nanowire.
	* phi [rad], wvlth [nm], Rnw [nm], n_idx [1], Ei0 [V.m^-1], N_mie [1]
	*/
	//float c_light      = 299792458.0; // [m.s^-1]
	//float eps0         = 8.85418782e-12; // [F.m^−1]
	// ---
	float rho          = 2.0*PI/wvlth * Rnw;
	// ---
	float Ir           = 0.0 ;
	vec2 Ir_tmp        = vec2(0.0);
	// ---
	vec2 amp_coeff_ij  = vec2(1.0); //c_light*eps0/2. * Ei0*cx_conj(Ei0);
	// ---
	vec2 As_m[20];
	for (int m=0; m<N_mie;m++){
		As_m[m] = as_m(m, 1.0, n_idx, rho);
	}
	// ---
	for (int m0=0; m0<N_mie; m0++)
	for (int l0=0; l0<m0+1 ; l0++)
	{
		//Ir_tmp  = ( cx_mul(amp_coeff_ij ,  cx_mul(as_m(m0, 1.0, n_idx, rho) , cx_conj( as_m(l0, 1.0, n_idx, rho)))) );
		Ir_tmp  = ( cx_mul(amp_coeff_ij ,  cx_mul(As_m[m0], cx_conj( As_m[l0]))) );
		//Ir_tmp *= (1.0-2.0*float(abs(m0-l0)%2)) * (eps_m0_l0(m0,l0)) * cos(float(m0)*phi)*cos(float(l0)*phi);
		Ir += Ir_tmp.x * (1.0-2.0*float(abs(m0-l0)%2)) * eps_m0_l0(m0,l0) * cos(float(m0)*phi)*cos(float(l0)*phi);
	}
	// ---  --- //
	//Ir *=  wvlth/(PI*PI); // 2.0/(PI*k0)
	// ---  --- //
	return Ir;
}