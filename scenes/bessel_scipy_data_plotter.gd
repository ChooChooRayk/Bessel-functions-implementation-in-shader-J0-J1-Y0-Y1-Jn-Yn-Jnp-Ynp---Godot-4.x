@tool
extends Control
class_name BesselPlotterFromTxtData

enum BESSEL_TYPE {
	J,
	Y,
	Jp,
	Yp,
	H1,
	H2,
}

@export var path_to_dir := ""
@export var bessel_type :BESSEL_TYPE = BESSEL_TYPE.J
@export var bessel_idx  := 0

@onready var function_line: Line2D = get_child(0)

var path_to_data_format := "data_{type}{idx}.txt"
var path_to_data :String

func make_path_to_data()->void:
	var type_str : String = ""
	match bessel_type:
		BESSEL_TYPE.J:
			type_str = "j"
		BESSEL_TYPE.Y:
			type_str = "y"
		BESSEL_TYPE.H1:
			type_str = "h1"
		BESSEL_TYPE.H2:
			type_str = "h2"
		BESSEL_TYPE.Jp:
			type_str = "jp"
		BESSEL_TYPE.Yp:
			type_str = "yp"
	# ---
	path_to_data = path_to_dir+path_to_data_format.format({"type":type_str, "idx":bessel_idx})
	function_line._path_to_line_data_points = path_to_data
