// ====== ========== ====== //
// ====== BESSEL : J ====== //
// ====== ========== ====== //

// From : https://www.shadertoy.com/view/Wt3czM
// https://link.springer.com/article/10.1007/s40314-020-01238-z
float BesselJ0(float x) {
    float xx   = x * x;
    float lamb = 0.865;
    float q    = 0.7172491568;
    float p0   = 0.6312725339;
    float ps0  = 0.4308049446;
    float p1   = 0.3500347951;
    float ps1  = 0.4678202347;
    float p2   =-0.06207747907;
    float ps2  = 0.04253832927;
    // ---
    float lamb4 = (lamb * lamb) * (lamb * lamb);
    float t0 = sqrt(1.0 + lamb4 * xx);
    float t1 = sqrt(t0);
    // ---
    // Ternary operator
    // if xx==0, then 1.0, else the reste of the expression
    return xx==0.0 ? 1.0 : 1.0/(t1 * (1.0 + q * xx)) * ((p0 + p1*xx + p2*t0) * cos(x) + ((ps0 + ps1*xx) * t0 + ps2*xx) * (sin(x)/x));
}
// https://www.sciencedirect.com/science/article/pii/S2211379718300111
float BesselJ1(float x) {
    float xx = x * x;
    // ---
    return (sqrt(1.0 + 0.12138 * xx) * (46.68634 + 5.82514 * xx) * sin(x) - x * (17.83632 + 2.02948 * xx) * cos(x)) / ((57.70003 + 17.49211 * xx) * pow(1.0 + 0.12138 * xx, 3.0/4.0) );
}
// using recurrence relation : Z_np1 = 2*n/x * Z_n - Z_nm1, wih Z=J,Y,H1,H2
float BesselJn(int n, float x) {
    if (n==0) {
        return BesselJ0(x);
    }
    if (n==1) {
        return BesselJ1(x);
    }
    // --- recursion
    float jim1 = BesselJ0(x);
    float ji   = BesselJ1(x);
    float jip1 = 0.0;
    for (int i=1; i<n; i++) {
        jip1 = 2.*float(i)/x * ji - jim1;
        // ---
        jim1 = ji;
        ji   = jip1;
    }
    return jip1;
}

 //small values
float BesselJ0_small(float x) {
    float z  = x * x;
    // ---
    float p0 = -4.79443220978201773821E9;
    float p1 = 1.95617491946556577543E12;
    float p2 = -2.49248344360967716204E14;
    float p3 = 9.70862251047306323952E15;
    // ---
    float q0 = 1.0;
    float q1 = 4.99563147152651017219E2;
    float q2 = 1.73785401676374683123E5;
    float q3 = 4.84409658339962045305E7;
    float q4 = 1.11855537045356834862E10;
    float q5 = 2.11277520115489217587E12;
    float q6 = 3.10518229857422583814E14;
    float q7 = 3.18121955943204943306E16;
    float q8 = 1.71086294081043136091E18;
    // ---
    float DR10 = 5.78318596294678452118E0;
    float DR20 = 3.04712623436620863991E1;
    // ---
    float N = p0*pow(z,3) + p1*pow(z,2) + p2*pow(z,1) + p3;
    float D = q0*pow(z,8) + q1*pow(z,7) + q2*pow(z,6) + q3*pow(z,5) + q4*pow(z,4) + q5*pow(z,3) + q6*pow(z,2) + q7*pow(z,1) + q8;
    // ---
    // Ternary operator
    // if xx==0, then 1.0, else the reste of the expression
    return z<1E-5 ? 1.0-z/4.0 : (z - DR10)*(z - DR20) * N/D;
}

float BesselJ1_small(float x) {
    float z   = x * x;
    // ---
    float p0 = -8.99971225705559398224E8;
    float p1 = 4.52228297998194034323E11;
    float p2 = -7.27494245221818276015E13;
    float p3 = 3.68295732863852883286E15;
    // ---
    float q0 =  1.0;
    float q1 =  6.20836478118054335476E2;
    float q2 =  2.56987256757748830383E5;
    float q3 =  8.35146791431949253037E7;
    float q4 =  2.21511595479792499675E10;
    float q5 =  4.74914122079991414898E12;
    float q6 =  7.84369607876235854894E14;
    float q7 =  8.95222336184627338078E16;
    float q8 =  5.32278620332680085395E18;
    // ---
    float Z1 = 1.46819706421238932572E1;
    float Z2 = 4.92184563216946036703E1;
    // ---
    float N = p0*pow(z,3) + p1*pow(z,2) + p2*pow(z,1) + p3;
    float D = q0*pow(z,8) + q1*pow(z,7) + q2*pow(z,6) + q3*pow(z,5) + q4*pow(z,4) + q5*pow(z,3) + q6*pow(z,2) + q7*pow(z,1) + q8;
    // ---
    // Ternary operator
    // if xx==0, then 1.0, else the reste of the expression
    return x*(z - Z1)*(z - Z2) * N/D;
}

float Bessel_Jvn_small(int n, float x) {
	int m = 14;
    float mm = float(m), nn = float(n);
    float s = 0.0, h = 0.5 * PI/mm;
    
    for (int k = 0; k < m; k++)
    {
        float t = h * (float(k) + 0.5);
        s += (((n & 1) == 1) ? (sin(x * sin(t)) * sin(nn * t)) : (cos(x * cos(t)) * cos(nn * t)))/mm;
    }
    
    return ((n & 1) == 1) ? s : (((((n >> 1) & 1) == 1) ? -1.0 : 1.0) * s);
}

// ---  --- //

float Bessel_Jvn(int n, float x) {
    float sing_prefac = 1.0;
    if (n<0) {
        sing_prefac = (1.0 - 2.0*float(abs(n)%2));
    }
    return abs(x)<25.0 ? sing_prefac*Bessel_Jvn_small(abs(n), x) : sing_prefac*BesselJn(abs(n), x);
}

float Bessel_Jvpn(int n, float x) {
    return (Bessel_Jvn(n-1, x) - Bessel_Jvn(n+1, x))/2.0;
}