/*
	BESSEL : H1, H2
*/

#include "./bessel_functions_J.gdshaderinc"
#include "./bessel_functions_Y.gdshaderinc"

vec2 BesselH1n(int n, float x) {
	return vec2(BesselJn(n,x), BesselYn(n,x));
}

vec2 BesselH2n(int n, float x) {
	return vec2(BesselJn(n,x),-BesselYn(n,x));
}

vec2 Bessel_H1vn(int n, float x) {
	return vec2(Bessel_Jvn(n,x), Bessel_Yvn(n,x));
}

vec2 Bessel_H2vn(int n, float x) {
	return vec2(Bessel_Jvn(n,x),-Bessel_Yvn(n,x));
}

vec2 Bessel_H1vpn(int n, float x) {
	return vec2(Bessel_Jvpn(n,x), Bessel_Yvpn(n,x));
}

vec2 Bessel_H2vpn(int n, float x) {
	return vec2(Bessel_Jvpn(n,x),-Bessel_Yvpn(n,x));
}