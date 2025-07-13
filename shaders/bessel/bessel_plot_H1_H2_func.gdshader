shader_type canvas_item;

uniform vec2 _scale_axes  = vec2(1.0,1.0); // [pxl,pxl]
uniform vec2 grid_origin  = vec2(0.0); // [pxl,pxl]
uniform float _line_width : hint_range(0.0, 0.1, 0.001) = 0.01;
uniform int which_bessel_func : hint_range(0, 3, 1) = 0;
// --- BESSEL FUNCTIONS --- //
#include "./bessel_functions_J.gdshaderinc"
#include "./bessel_functions_Y.gdshaderinc"
#include "./bessel_functions_H1H2.gdshaderinc"
group_uniforms Bessel;
uniform int _n  = 0; // [i]
uniform float _var_min =-1.0;
uniform float _var_max = 1.0;
uniform int _pts_nbr = 10;

vec2 SetUVMathCoordinate(vec2 uv) {
    vec2 uv_coord = uv - 0.5;
    uv_coord *= _scale_axes;
    uv_coord -= grid_origin;
    return uv_coord;
}

vec2 eval_bessel_Hi(int which, int n, float x) {
	vec2 func_xy = vec2(0.0, 0.0);
	switch (which_bessel_func) {
	    case 0:
	        func_xy = Bessel_H1vn(n,x);
			break;
	    case 1:
	        func_xy = Bessel_H2vn(n,x);
			break;
	    case 2:
	        func_xy = Bessel_H1vpn(n,x);
			break;
	    case 3:
	        func_xy = Bessel_H2vpn(n,x);
			break;
	}
	return func_xy;
}

float dist_to_segmnt(in vec2 A, in vec2 B, in vec2 M) {
	float r = dot(normalize(B-A),M-A);
	r = 0.5*(r+abs(r));
	float d = dot(M-A,M-A) - pow(r,2);
	d = float(r>length(B-A))*length(M-B) + float(r<=length(B-A))*pow(abs(d),0.5);
	return d;
}

void fragment() {
	vec2 uv_centered = SetUVMathCoordinate(UV);
	float X = uv_centered.x;
	float Y =-uv_centered.y;
	// ---
	float line = 0.0;
	for (int j=0; j<_pts_nbr; j++) {
		float sj = _var_min + float(j)/float(_pts_nbr)*(_var_max-_var_min);
		vec2 pt1 = eval_bessel_Hi(which_bessel_func, _n, sj);
		vec2 pt2 = eval_bessel_Hi(which_bessel_func, _n, sj+1.0/float(_pts_nbr)*(_var_max-_var_min));
		// ---
		float tmp = dist_to_segmnt(pt1, pt2, uv_centered);
		line += 1.0-step(_line_width, tmp);
	}
    // ---
    float mask = 1.0;
	mask *= line;
    //mask *=-step(_line_width,line)+1.0;
    //mask *=-step(+_line_width,X/_scale_y-Y/_scale_x)+1.0;
    //mask *= step(-_line_width,X/_scale_y-Y/_scale_x);
    // ---
    //COLOR.rgb = vec3(line);
    COLOR.a = mask;
}
