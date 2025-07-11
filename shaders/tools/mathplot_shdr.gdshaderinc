vec2 SetUVMathCoordinate(vec2 uv, vec2 grid_origin, vec2 _scale_axes) {
    vec2 uv_coord = uv - 0.5;
    uv_coord *= _scale_axes;
    uv_coord -= grid_origin;
    return uv_coord;
}