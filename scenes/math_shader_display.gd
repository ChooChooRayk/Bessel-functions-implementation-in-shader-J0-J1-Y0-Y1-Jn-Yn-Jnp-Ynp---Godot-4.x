@tool
extends Control
#class_name MathShaderDisplay


@onready var grid    : ShaderMaterial = $Grid    .material
@onready var origin  : ShaderMaterial = $Origin  .material
@onready var function: ShaderMaterial = $Function.material
@onready var function_line: Line2D = %FunctionLine
@onready var bessel_plotter_from_txt_data: Control = $BesselScipyDataPlotter


@export var update := false
@export_category("Math Params")
@export var x_min :=-1.0
@export var x_max := 1.0
@export var y_min :=-1.0
@export var y_max := 1.0
@export_category("Specific bessel")
@export var bessel_idx  := 0
@export var bessel_type  :BesselPlotterFromTxtData.BESSEL_TYPE = BesselPlotterFromTxtData.BESSEL_TYPE.Jp



func _ready() -> void:
	update = true

func _process(delta: float) -> void:
	if update:
		update_shader_params()
		# ---
		bessel_plotter_from_txt_data.bessel_idx  = bessel_idx
		bessel_plotter_from_txt_data.bessel_type = bessel_type
		function.set_shader_parameter("_n", bessel_idx)
		# ---
		bessel_plotter_from_txt_data.make_path_to_data()
		function_line.set_plot_frame(x_min, x_max,y_min, y_max)
		function_line.extract_data()
		function_line.set_line()
		update = false
	pass
	
func update_shader_params()->void:
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
	function.set_shader_parameter("_scale_axes", Vector2(x_amp, y_amp))
	function.set_shader_parameter("grid_origin", origin_pos)
	function.set_shader_parameter("which_bessel_func", int(bessel_type))
	return
