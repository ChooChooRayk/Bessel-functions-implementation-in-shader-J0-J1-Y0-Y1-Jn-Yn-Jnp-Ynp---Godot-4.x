shader_type canvas_item;

uniform vec2 grid_period  = vec2(1.0,1.0); // [pxl,pxl]
uniform vec2 grid_origin  = vec2(0.0); // [pxl,pxl]
uniform vec2 _scale_axes  = vec2(1.0,1.0); // [pxl,pxl]
uniform vec3 line_color:source_color = vec3(0.2,0.3,0.5);
uniform float thickness:hint_range(0.001, 1.0, 0.001) = 0.1;

float draw_grid(vec2 uv) {
    vec2 grid_uv = fract( (uv/grid_period));
    return max(grid_uv.x, grid_uv.y);
}

void fragment() {
    vec2 uv = (UV-0.5);
    uv     *= (_scale_axes);
    uv     -= grid_origin;
    // ---
    vec2 grid_uv = fract( (uv/grid_period));
    float is_line = 0.0;
    //is_line *= step(1.0-thickness, draw_grid(uv));
    float line_x = -step(0.01*thickness*_scale_axes.x/grid_period.x, grid_uv.x)+1.0;
    float line_y = -step(0.01*thickness*_scale_axes.y/grid_period.y, grid_uv.y)+1.0;
    is_line += max(line_x,line_y);
    // ---
    vec3 color  = vec3( is_line )*line_color;
    COLOR       = vec4(color, is_line);
}
