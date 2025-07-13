@tool
extends Control
#class_name MathShaderDisplay


@onready var grid    : ShaderMaterial = $Grid    .material
@onready var origin  : ShaderMaterial = $Origin  .material
@onready var function: ShaderMaterial = $Function.material
@onready var function_line: PlotLine2D = %FunctionLine
@onready var bessel_plotter_from_txt_data: BesselPlotterFromTxtData = $BesselScipyDataPlotter


@export_tool_button("Update plot") var update_action := update_plot
@export_category("Math Params")
@export var x_min :=-1.0
@export var x_max := 1.0
@export var y_min :=-1.0
@export var y_max := 1.0
@export_category("Specific bessel")
@export var bessel_idx  := 0
@export var bessel_type  :BesselPlotterFromTxtData.BESSEL_TYPE = BesselPlotterFromTxtData.BESSEL_TYPE.Jp
@export_file(".gdshader") var shader_plot_J_Y   = "res://shaders/bessel/bessel_plot_J_Y_func.gdshader"
@export_file(".gdshader") var shader_plot_H1_H2 = "res://shaders/bessel/bessel_plot_H1_H2_func.gdshader"

var shader_file_path : StringName


func update_plot()->void:
	update_shader_params()
	# ---
	bessel_plotter_from_txt_data.bessel_idx  = bessel_idx
	bessel_plotter_from_txt_data.bessel_type = bessel_type
	function.set_shader_parameter("_n", bessel_idx)
	# ---
	bessel_plotter_from_txt_data.make_path_to_data()
	bessel_plotter_from_txt_data.extract_data()
	var x_data :Array[float]= []
	var y_data :Array[float]= []
	# ---
	if bessel_type in [BesselPlotterFromTxtData.BESSEL_TYPE.J,BesselPlotterFromTxtData.BESSEL_TYPE.Y,BesselPlotterFromTxtData.BESSEL_TYPE.Jp, BesselPlotterFromTxtData.BESSEL_TYPE.Yp]:
		x_data.assign(bessel_plotter_from_txt_data.data_array.map(func (elmt:Vector3): return elmt.x))
		y_data.assign(bessel_plotter_from_txt_data.data_array.map(func (elmt:Vector3): return elmt.y))
	else:
		x_data.assign(bessel_plotter_from_txt_data.data_array.map(func (elmt:Vector3): return elmt.y))
		y_data.assign(bessel_plotter_from_txt_data.data_array.map(func (elmt:Vector3): return elmt.z))
	# ---
	function_line.set_plot_frame(x_min, x_max,y_min, y_max)
	function_line.plot(x_data, y_data)
	return

func update_shader_params()->void:
	var shdr_special_var:Array = []
	if bessel_type in [BesselPlotterFromTxtData.BESSEL_TYPE.J, BesselPlotterFromTxtData.BESSEL_TYPE.Y, BesselPlotterFromTxtData.BESSEL_TYPE.Jp, BesselPlotterFromTxtData.BESSEL_TYPE.Yp]:
		shader_file_path = shader_plot_J_Y
	else:
		shader_file_path = shader_plot_H1_H2
		shdr_special_var = [0.01, 20.0]
	# ---
	var x_amp := (x_max-x_min)
	var y_amp := (y_max-y_min)
	var origin_pos = -Vector2((x_max+x_min)/2., -(y_max+y_min)/2.)
	# ---
	grid.set_shader_parameter("_scale_axes", Vector2(x_amp, y_amp))
	grid.set_shader_parameter("grid_origin", origin_pos)
	# ---
	origin.set_shader_parameter("_scale_axes", Vector2(x_amp, y_amp))
	origin.set_shader_parameter("grid_origin", origin_pos)
	origin.set_shader_parameter("grid_period", Vector2(x_amp, y_amp))
	# ---
	function.shader = load(shader_file_path) as Shader
	function.set_shader_parameter("_scale_axes", Vector2(x_amp, y_amp))
	function.set_shader_parameter("grid_origin", origin_pos)
	function.set_shader_parameter("which_bessel_func", int(bessel_type)%4)
	if shdr_special_var.size()!=0:
		function.set_shader_parameter("_pts_nbr", 100)
		function.set_shader_parameter("_var_min", shdr_special_var[0])
		function.set_shader_parameter("_var_max", shdr_special_var[1])
	return
