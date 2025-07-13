vec2 SetUVMathCoordinate(vec2 uv, vec2 grid_origin, vec2 _scale_axes) {
    vec2 uv_coord = uv - 0.5;
    uv_coord *= _scale_axes;
    uv_coord -= grid_origin;
    return uv_coord;
}

float dist_to_segmnt(in vec2 A, in vec2 B, in vec2 M) {
	float r = dot(normalize(B-A),M-A);
	r = 0.5*(r+abs(r));
	float d = dot(M-A,M-A) - pow(r,2);
	d = float(r>length(B-A))*length(M-B) + float(r<=length(B-A))*pow(abs(d),0.5);
	return d;
}