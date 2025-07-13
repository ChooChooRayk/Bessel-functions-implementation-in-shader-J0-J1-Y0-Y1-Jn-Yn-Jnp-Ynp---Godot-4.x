@tool
class_name BesselPlotterFromTxtData
extends Control

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
var path_to_data : String
var data_array : Array[Vector3]

func make_path_to_data()->void:
	var type_str : String = ""
	match bessel_type:
		BESSEL_TYPE.J:
			type_str = "j"
		BESSEL_TYPE.Y:
			type_str = "y"
		BESSEL_TYPE.H1:
			type_str = "h1_n"
		BESSEL_TYPE.H2:
			type_str = "h2_n"
		BESSEL_TYPE.Jp:
			type_str = "jp"
		BESSEL_TYPE.Yp:
			type_str = "yp"
	# ---
	path_to_data = path_to_dir+path_to_data_format.format({"type":type_str, "idx":bessel_idx})
	#function_line.set_path_to_data_points(path_to_data)

#region: MANAGEMENT

func extract_data()->void:
	var file = FileAccess.open(path_to_data, FileAccess.READ)
	# ---
	var extrct_lines : Array[PackedStringArray]
	while !file.eof_reached():
		var line = file.get_csv_line()
		extrct_lines.append(line)
	# ---
	var col_nbr :int= extrct_lines.size()-1
	var row_nbr :int= extrct_lines[0].size()
	data_array.clear()
	for i in range(row_nbr):
		var func_xy :Array[float]= [0.0,0.0,0.0]
		for k in range(col_nbr):
			func_xy[k] = float(extrct_lines[k][i])
		data_array.append(Vector3(func_xy[0],-func_xy[1],func_xy[2]))# x, -y, z ; -y because y-axis direction is downward
	return

#endregion
