// ====== ========== ====== //
// ====== BESSEL : Y ====== //
// ====== ========== ====== //

#include "./bessel_functions_J.gdshaderinc"
#include "./bessel_functions_Y0_Y1_gsl.gdshaderinc"

float BesselYn(int n, float x) {
    if (n==0) {
        return gsl_sf_bessel_Y0(x);
    }
    if (n==1) {
        return gsl_sf_bessel_Y1(x);
    }
    // --- recursion
    float yim1 = gsl_sf_bessel_Y0(x);
    float yi   = gsl_sf_bessel_Y1(x);
    float yip1 = 0.0;
    for (int i=1; i<n; i++) {
        yip1 = 2.*float(i)/x * yi - yim1;
        // ---
        yim1 = yi;
        yi   = yip1;
    }
    return yip1;
}

float Bessel_Yvn(int n, float x) {
    float sing_prefac = 1.0;
    if (n<0) {
        sing_prefac = (1.0 - 2.0*float(abs(n)%2));
    }
    return sing_prefac*BesselYn(abs(n), x);
}

float Bessel_Yvpn(int n, float x) {
    return (Bessel_Yvn(n-1, x) - Bessel_Yvn(n+1, x))/2.0;
}