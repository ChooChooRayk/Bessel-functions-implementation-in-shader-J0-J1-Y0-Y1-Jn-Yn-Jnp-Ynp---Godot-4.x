@tool
extends Line2D

@export var _path_to_line_data_points : String

var data_pts  : Array[Vector2]
var xy_min: Vector2 = -Vector2.ONE
var xy_max: Vector2 = +Vector2.ONE

func set_plot_frame(x_min, x_max,y_min, y_max)->void:
	xy_min = Vector2(x_min, y_min)
	xy_max = Vector2(x_max, y_max)
	
func set_line()->void:
	clear_points()
	# ---
	var plot_frame :Vector2= get_parent().size
	var rescale_amp:= xy_max-xy_min
	var origin_pos := -(xy_max+xy_min)/2.
	origin_pos.x *= -1.0
	# ---
	for i in range(data_pts.size()):
		var new_pt :Vector2 = data_pts[i]
		# ---
		new_pt *= plot_frame/rescale_amp
		new_pt -= origin_pos * plot_frame/rescale_amp
		# --- reframe in same windows as the UV
		new_pt += plot_frame/2.
		# ---
		add_point(new_pt)
	return

func extract_data()->void:
	var file = FileAccess.open(_path_to_line_data_points, FileAccess.READ)
	# ---
	var extrct_lines : Array[PackedStringArray]
	while !file.eof_reached():
		var line = file.get_csv_line()
		extrct_lines.append(line)
	# ---
	data_pts.clear()
	for i in range(extrct_lines[0].size()):
		var func_xy := Vector2(float(extrct_lines[0][i]),-float(extrct_lines[1][i]))
		data_pts.append(func_xy)
	return
