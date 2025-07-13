shader_type spatial;
/*
Mixe from:
	- godotshaders.com/shader/cracked-glass/
	- www.shadertoy.com/view/ll3SD2
*/

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

group_uniforms GlobalParams;
uniform float progress :hint_range(0.0, 1.0, 0.001) = 0.0;
uniform vec2 scale  = vec2(1.0);
uniform vec2 offset = vec2(0.0);
uniform vec4 crack_color :source_color= vec4(0.0, 0.0, 0.0, 1.0);
uniform float energy_mult:hint_range(0.0, 10.0, 0.1)=1.0;
group_uniforms ParameterRelation;//relation between progress variable and the different thresholds to make the cracks appear
uniform float var1 = 0.01;
uniform float var2 = 3.5;
uniform float var3 = 0.1;


float progrss_to_crack_thrsh(in float thrsh) {
	float new_thrsh = exp(-var1/(1.0-thrsh+0.0001))/exp(-var1);
	return new_thrsh;
}

float progrss_to_dist_thrsh(in float thrsh) {
	float new_thrsh = (1.0-thrsh)*var2;
	return new_thrsh;
}

vec2 hash(in vec2 p) {
	// --- procedural white noise
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453123);
}

vec4 voronoi(in vec2 uv_coord) {
    vec2 p = floor(uv_coord);
    vec2 f = fract(uv_coord);
	// ---
    float res = 8.0;
    vec2 mr, mg;
    for (int j = -1; j <= 1; j++)
    for (int i = -1; i <= 1; i++)
	{
        vec2 g = vec2(float(i), float(j));
        vec2 o = hash(p + g);
        vec2 r = g - f + o;
        float d = dot(r, r);
        if (d < res) {
            res = d;
            mr  = r;
			mg  = g;
        }
    }
	float oldDist = res;
	// --- Distance to border
    res = 8.0;
    for (int j = -2; j <= 2; j++)
    for (int i = -2; i <= 2; i++)
	{
        vec2 g = mg + vec2(float(i), float(j));
        vec2 o = hash(p + g);
        vec2 r = g - f + o;
        float d = dot(mr-r, mr-r);
        if (d>progrss_to_dist_thrsh(progress)) {
            res = min(res, dot(0.5*(mr+r), normalize((r-mr))));
        }
    }
	// ---
    return vec4(res, mr, oldDist);
}

void fragment() {
	vec2 uv_scaled = (UV-vec2(0.5) + offset)*scale;
	ALBEDO.rgb = crack_color.rgb;
	// ---
	vec4 voro_vec = voronoi(uv_scaled);
	float mask = voro_vec.x;
	mask = 1.0 - pow(1.0-mask,2.0);
	mask = step(progrss_to_crack_thrsh(progress), 1.0-mask);
	// --- mask for having pointy lines --> failed attempt :(
	float mask_2 = 1.0;//voro_vec.w;
	//float thrs_2 = (1.0 - 1.1*exp(var3*progress)/exp(var3))*0.1;
	//thrs_2 = clamp(thrs_2, 0.0, 1.0);
	//mask_2 = pow(mask_2,3.0);
	//mask_2 = smoothstep(thrs_2-0.001, thrs_2, mask_2);
	// ---
	ALPHA = mask * mask_2;
	EMISSION = crack_color.rgb * energy_mult;
}
