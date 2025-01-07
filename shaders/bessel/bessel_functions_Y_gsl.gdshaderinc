#include "./bessel_functions_J.gdshaderinc"

// ====== ========== ====== //
// ====== Adaptation of GSL bessel Y ====== //
// ====== ========== ====== //
/* Documentation on GSL - GNU scientific library:
*   https://www.gnu.org/software/gsl/doc/html/index.html
* To get the base code in C, go to : https://www.gnu.org/software/gsl/
*/
#define GSL_DBL_EPSILON 2.2204460492503131e-16
#define GSL_ROOT5_DBL_EPSILON  7.4009597974140505e-04
#define GSL_SQRT_DBL_EPSILON   1.4901161193847656e-08
#define LN2 0.69314718055994530941723212146      /* ln(2) */
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


// ====== Y0 ====== //

const float bm0_data[30] = {
    0.09284961637381644,
   -0.00142987707403484,
    0.00002830579271257,
   -0.00000143300611424,
    0.00000012028628046,
   -0.00000001397113013,
    0.00000000204076188,
   -0.00000000035399669,
    0.00000000007024759,
   -0.00000000001554107,
    0.00000000000376226,
   -0.00000000000098282,
    0.00000000000027408,
   -0.00000000000008091,
    0.00000000000002511,
   -0.00000000000000814,
    0.00000000000000275,
   -0.00000000000000096,
    0.00000000000000034,
   -0.00000000000000012,
    0.00000000000000004,
    0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
};
const cheb_series_type _gsl_sf_bessel_amp_phase_bm0_cs = cheb_series_type(
    bm0_data,
    20,
    -1.0,
    1.0
);

const float bth0_data[30] = {
    -0.24639163774300119,
    0.001737098307508963,
    -0.000062183633402968,
    0.000004368050165742,
    -0.000000456093019869,
    0.000000062197400101,
    -0.000000010300442889,
    0.000000001979526776,
    -0.000000000428198396,
    0.000000000102035840,
    -0.000000000026363898,
    0.000000000007297935,
    -0.000000000002144188,
    0.000000000000663693,
    -0.000000000000215126,
    0.000000000000072659,
    -0.000000000000025465,
    0.000000000000009229,
    -0.000000000000003448,
    0.000000000000001325,
    -0.000000000000000522,
    0.000000000000000210,
    -0.000000000000000087,
    0.000000000000000036,
    0.0,0.0,0.0,0.0,0.0,0.0
};
const cheb_series_type _gsl_sf_bessel_amp_phase_bth0_cs = cheb_series_type(
    bth0_data,
    23,
    -1.0, 1.0
);

const float by0_data[30] = {
  -0.011277839392865573,
  -0.128345237560420350,
  -0.104378847997942490,
   0.023662749183969695,
  -0.002090391647700486,
   0.000103975453939057,
  -0.000003369747162423,
   0.000000077293842676,
  -0.000000001324976772,
   0.000000000017648232,
  -0.000000000000188105,
   0.000000000000001641,
  -0.000000000000000011,
   0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
};
const cheb_series_type by0_cs = cheb_series_type(
  by0_data,
  12,
  -1.0, 1.0
  //8
);

float gsl_sf_bessel_Y0(const float x) {
    float val;
    float err;
    // ---
    const float two_over_pi = 2.0/PI;
    const float xmax        = 1.0/GSL_DBL_EPSILON;
    // ---
    if (x <= 0.0) {
        return 0.0;
    }
    else if(x < 4.0) {
        float J0 = BesselJ0(x);
        float c = cheb_series(by0_cs, 0.125*x*x-1.0);
        val = two_over_pi*(-LN2 + log(x))*J0 + 0.375 + c;
        //err = 2.0 * GSL_DBL_EPSILON * abs(val) + cheb_series.err;
        return val;
    }
    else if(x < xmax) {
        /* Leading behaviour of phase is x, which is exact,
        * so the error is bounded.
        */
        const float z  = 32.0/(x*x) - 1.0;
        float c1 = cheb_series(_gsl_sf_bessel_amp_phase_bm0_cs,  z);
        float c2 = cheb_series(_gsl_sf_bessel_amp_phase_bth0_cs, z);
        float sp = gsl_sf_bessel_sin_pi4_e(x, c2/x);
        float sqrtx = sqrt(x);
        float ampl  = (0.75 + c1) / sqrtx;
        val  = ampl * sp;
        //err  = abs(sp.val) * c1.err/sqrtx + abs(ampl) * sp.err;
        //err += 2.0 * GSL_DBL_EPSILON * abs(val);
        return val;
    }
    else {
        return 0.0;
    }
}

// ====== Y1 ====== //
#define GSL_DBL_MIN        2.2250738585072014e-308

const float bm1_data[30] = {
   0.1047362510931285, 
   0.00442443893702345,
  -0.00005661639504035,
   0.00000231349417339,
  -0.00000017377182007,
   0.00000001893209930,
  -0.00000000265416023,
   0.00000000044740209,
  -0.00000000008691795,
   0.00000000001891492,
  -0.00000000000451884,
   0.00000000000116765,
  -0.00000000000032265,
   0.00000000000009450,
  -0.00000000000002913,
   0.00000000000000939,
  -0.00000000000000315,
   0.00000000000000109,
  -0.00000000000000039,
   0.00000000000000014,
  -0.00000000000000005,
   0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
};
const cheb_series_type _gsl_sf_bessel_amp_phase_bm1_cs = cheb_series_type(
  bm1_data,
  20,
  -1.0, 1.0
  //10
);

const float bth1_data[30] = {
   0.74060141026313850, 
  -0.004571755659637690,
   0.000119818510964326,
  -0.000006964561891648,
   0.000000655495621447,
  -0.000000084066228945,
   0.000000013376886564,
  -0.000000002499565654,
   0.000000000529495100,
  -0.000000000124135944,
   0.000000000031656485,
  -0.000000000008668640,
   0.000000000002523758,
  -0.000000000000775085,
   0.000000000000249527,
  -0.000000000000083773,
   0.000000000000029205,
  -0.000000000000010534,
   0.000000000000003919,
  -0.000000000000001500,
   0.000000000000000589,
  -0.000000000000000237,
   0.000000000000000097,
  -0.000000000000000040,
   0.0,0.0,0.0,0.0,0.0,0.0
};
const cheb_series_type _gsl_sf_bessel_amp_phase_bth1_cs = cheb_series_type(
  bth1_data,
  23,
  -1.0, 1.0
  //12
);

const float by1_data[30] = {
  0.03208047100611908629,
  1.262707897433500450,
  0.00649996189992317500,
 -0.08936164528860504117,
  0.01325088122175709545,
 -0.00089790591196483523,
  0.00003647361487958306,
 -0.00000100137438166600,
  0.00000001994539657390,
 -0.00000000030230656018,
  0.00000000000360987815,
 -0.00000000000003487488,
  0.00000000000000027838,
 -0.00000000000000000186,
  0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
};
const cheb_series_type by1_cs = cheb_series_type(
  by1_data,
  13,
  -1.0, 1.0
  //10
);

float gsl_sf_bessel_Y1(const float x) {
    float val;
    float err;
    // ---
    const float two_over_pi = 2.0/PI;
    const float xmin        = 1.571*GSL_DBL_MIN; /*exp ( amax1(alog(r1mach(1)), -alog(r1mach(2)))+.01) */
    const float x_small     = 2.0 * GSL_SQRT_DBL_EPSILON;
    const float xmax        = 1.0/GSL_DBL_EPSILON;

  /* CHECK_POINTER(result) */

    if(x <= 0.0) {
        return 0.0;
    }
    else if(x < xmin) {
        return 0.0;
    }
    else if(x < x_small) {
        const float lnterm = log(0.5*x);
        float J1 = BesselJ1(x);
        float c  = cheb_series(by1_cs, -1.0);
        val = two_over_pi * lnterm * J1 + (0.5 + c)/x;
        //err = abs(lnterm) * (abs(GSL_DBL_EPSILON * J1.val) + J1.err) + c.err/x;
        return val;
    }
    else if(x < 4.0) {
        const float lnterm = log(0.5*x);
        int status;
        float J1 = BesselJ1(x);
        float c  = cheb_series(by1_cs, 0.125*x*x-1.0);
        val = two_over_pi * lnterm * J1 + (0.5 + c)/x;
        //err = abs(lnterm) * (abs(GSL_DBL_EPSILON * J1.val) + J1.err) + c.err/x;
        return val;
    }
    else if(x < xmax) {
        const float z = 32.0/(x*x) - 1.0;
        float ca = cheb_series(_gsl_sf_bessel_amp_phase_bm1_cs,  z);
        float ct = cheb_series(_gsl_sf_bessel_amp_phase_bth1_cs, z);
        float cp = gsl_sf_bessel_cos_pi4_e(x, ct/x);
        const float sqrtx = sqrt(x);
        float ampl  = (0.75 + ca) / sqrtx;
        val  = -ampl * cp;
        //err  = fabs(cp) * ca.err/sqrtx + fabs(ampl) * cp.err;
        //err += GSL_DBL_EPSILON * fabs(result->val);
        return val;
    }
  else {
        return val;
  }
}