// ====== ========== ====== //
// ====== Adaptation of GSL bessel functions ====== //
// ====== ========== ====== //
/* Documentation on GSL - GNU scientific library:
*   https://www.gnu.org/software/gsl/doc/html/index.html
* To get the base code in C, go to : https://www.gnu.org/software/gsl/
*/
#define GSL_DBL_EPSILON 2.2204460492503131e-16
#define GSL_ROOT5_DBL_EPSILON  7.4009597974140505e-04
#define GSL_SQRT_DBL_EPSILON   1.4901161193847656e-08
#define SQRT2    1.41421356237309504880168872421      /* sqrt(2) */

struct cheb_series_type {
    float coeff[30];
    int order;
    float x_min;
    float x_max;
};

float cheb_poly_Tn(int n, float x) {
    if (n==0) {
        return 1.0;
    } else if (n==1) {
        return x;
    }
    // ---
    float Tim1 = 1.0;
    float Ti   = x;
    float Tip1 = 0.0;
    for (int i=1; i<n; i++) {
        Tip1 = 2.0*x*Ti - Tim1;
        // ---
        Tim1 = Ti;
        Ti   = Tip1;
    }
    return Tip1;
}

float cheb_series(cheb_series_type cs, float x) {
    int order = cs.order;
    float y  = (2.0*x - cs.x_min - cs.x_max)/(cs.x_max-cs.x_min);
    float y2 = 2.0*y;
    // ---
    float d  = 0.0;
    float e  = 0.0;
    float dd = 0.0;
    // ---
    for(int j=order; j>=1; j--) {
        float temp = d;
        d = y2*d - dd + cs.coeff[j];
        e += abs(y2*temp) + abs(dd) + abs(cs.coeff[j]);
        dd = temp;
    }
    {
    float temp = d;
        d = y*d - dd + 0.5 * cs.coeff[0];
        e += abs(y*temp) + abs(dd) + 0.5 * abs(cs.coeff[0]);
    }
    float val = d;
    float err =  GSL_DBL_EPSILON * e + abs(cs.coeff[order]);
    return val;
}

float gsl_sf_bessel_sin_pi4_e(float y, float eps) {
    float sy = sin(y);
    float cy = cos(y);
    float s = sy + cy;
    float d = sy - cy;
    float abs_sum = abs(cy) + abs(sy);
    float seps;
    float ceps;
    // ---
    if(abs(eps) < GSL_ROOT5_DBL_EPSILON) {
        float e2 = eps*eps;
        seps = eps * (1.0 - e2/6.0 * (1.0 - e2/20.0));
        ceps = 1.0 - e2/2.0 * (1.0 - e2/12.0);
    }
    else {
        seps = sin(eps);
        ceps = cos(eps);
    }
    float val = (ceps * d + seps * s)/ SQRT2;
    float err = 2.0 * GSL_DBL_EPSILON * (abs(ceps) + abs(seps)) * abs_sum / SQRT2;

    /* Try to account for error in evaluation of sin(y), cos(y).
    * See above.
    * FIXME ?
    if(y > 1.0/GSL_DBL_EPSILON) {
    err *= 0.5 * y;
    }
    else if(y > 1.0/GSL_SQRT_DBL_EPSILON) {
    err *= 256.0 * y * GSL_SQRT_DBL_EPSILON;
    }
    */

    return val;
}

float gsl_sf_bessel_cos_pi4_e(const float y, float eps) {
    float val;
    float err;
    // ---
    const float sy = sin(y);
    const float cy = cos(y);
    const float s = sy + cy;
    const float d = sy - cy;
    const float abs_sum = abs(cy) + abs(sy);
    float seps;
    float ceps;
    if(abs(eps) < GSL_ROOT5_DBL_EPSILON) {
        float e2 = eps*eps;
        seps = eps * (1.0 - e2/6.0 * (1.0 - e2/20.0));
        ceps = 1.0 - e2/2.0 * (1.0 - e2/12.0);
    }
    else {
        seps = sin(eps);
        ceps = cos(eps);
    }
    val = (ceps * s - seps * d)/SQRT2;
    err = 2.0 * GSL_DBL_EPSILON * (abs(ceps) + abs(seps)) * abs_sum / SQRT2;

    /* Try to account for error in evaluation of sin(y), cos(y).
    * This is a little sticky because we don't really know
    * how the library routines are doing their argument reduction.
    * However, we will make a reasonable guess.
    * FIXME ?
    if(y > 1.0/GSL_DBL_EPSILON) {
        result->err *= 0.5 * y;
    }
    else if(y > 1.0/GSL_SQRT_DBL_EPSILON) {
        result->err *= 256.0 * y * GSL_SQRT_DBL_EPSILON;
    }
    */

    return val;
}
