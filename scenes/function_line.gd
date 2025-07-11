@tool
class_name PlotLine2D
extends Line2D

var data_pts  : Array[Vector2]
var xy_min: Vector2 = -Vector2.ONE
var xy_max: Vector2 = +Vector2.ONE

#region: PLOT methods

func plot(x:Array[float], y:Array[float])->void:
	assert(x.size()==y.size(), "Error x and y not the same size.")
	# ---
	data_pts.clear()
	data_pts.resize(x.size())
	for i in range(x.size()):
		data_pts[i] = Vector2(x[i], y[i])
	# ---
	set_line()
	return

#endregion

#region: MANAGEMENT

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

#endregion
