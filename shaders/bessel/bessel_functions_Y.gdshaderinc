// ====== ========== ====== //
// ====== BESSEL : Y ====== //
// ====== ========== ====== //

#include "./bessel_functions_J.gdshaderinc"
#include "./bessel_functions_Y_gsl.gdshaderinc"

float BesselY0(float x) {
    if (x <= 0.0) {
        return 0.0;
    };
    if (x < 2.0) {
        // Series expansion for small x (simplified)
        float z = x*x;
        return (2.0 / PI) * (log(x) * BesselJ0(x) - (1.0 / z));
    } else {
        // Asymptotic expansion for large x
        return sqrt(2.0 / (PI * x)) * sin(x - PI / 4.0);
    }
}

float BesselY0_bis(float x) {
    if (x <= 0.0) {
        return 0.0;
    }
    if (x < 0.01) {
        // Series expansion for small x
        float z = x * x;
        float term = -log(x) * (2.0 / PI);
        float sum = 0.0;
        float coefficients[] = {
            -0.57721566490153286060,  // Euler-Mascheroni constant
            0.42278433509846713940,
            -0.23069756036146337088,
            0.03488590166589656025,
            -0.00262609016310353777,
            0.00010731029253063772,
            -0.00000222783697462547
        };
        for (int k = 0; k < coefficients.length(); k++) {
            sum += coefficients[k] * pow(z, float(k));
        }
        return term + sum;
    } else {
        // Asymptotic expansion for large x
        float sqrt_term = sqrt(2.0 / (PI * x));
        float theta     = x - PI / 4.0;
        return sqrt_term * sin(theta);
    }
}

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