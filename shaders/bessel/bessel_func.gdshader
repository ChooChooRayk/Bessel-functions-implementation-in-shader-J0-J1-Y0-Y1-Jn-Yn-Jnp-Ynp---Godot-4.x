shader_type canvas_item;

uniform vec2 _scale_axes  = vec2(1.0,1.0); // [pxl,pxl]
uniform vec2 grid_origin  = vec2(0.0); // [pxl,pxl]
uniform float _line_width : hint_range(0.0, 0.1, 0.001) = 0.01;
uniform int which_bessel_func : hint_range(0, 5, 1) = 0;
// --- BESSEL FUNCTIONS --- //
#include "./bessel_functions_J.gdshaderinc"
#include "./bessel_functions_Y.gdshaderinc"
group_uniforms Bessel;
uniform int _n  = 0; // [i]


vec2 SetUVMathCoordinate(vec2 uv) {
    vec2 uv_coord = uv - 0.5;
    uv_coord *= _scale_axes;
    uv_coord -= grid_origin;
    return uv_coord;
}

void fragment() {
    vec2 uv_centered = SetUVMathCoordinate(UV);
    float X = uv_centered.x;
    float Y =-uv_centered.y;
    // ---
    float func_x;
    switch (which_bessel_func) {
        case 0:
            func_x = Bessel_Jvn(_n,X);
            break;
        case 1:
            func_x = Bessel_Yvn(_n,X);
            break;
        case 2:
            func_x = Bessel_Jvpn(_n,X);
            break;
        case 3:
            func_x = Bessel_Yvpn(_n,X);
            break;
        case 4:
            func_x = 0.0*X;
            break;
        case 5:
            func_x = 0.0*X;
            break;
    }
    float line = Y - func_x;
    line = abs(line);
    //line-= _line_width;
    // ---
    float mask = 1.0;
    mask *=-step(_line_width,line)+1.0;
    //mask *=-step(+_line_width,X/_scale_y-Y/_scale_x)+1.0;
    //mask *= step(-_line_width,X/_scale_y-Y/_scale_x);
    // ---
    //COLOR.rgb = vec3(line);
    COLOR.a = mask;
}
