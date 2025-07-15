extends Node3D

@onready var mie_scatt: MeshInstance3D = $MieScatt
@onready var laser: MeshInstance3D = $Laser
@onready var nw: MeshInstance3D = $NW

func _on_wavelength_changed(_wvl_nm:float)->void:
	$CanvasLayer/UI/MarginContainer/VBoxContainer/grid/WvlLbl.text = "%.1f"%_wvl_nm
	# ---
	var mie_shdr := mie_scatt.material_override as ShaderMaterial
	mie_shdr.set_shader_parameter("wvlth1_nm", _wvl_nm)
	var nw_aspect := nw.material_override as ShaderMaterial
	nw_aspect.set_shader_parameter("laser_wvlth", _wvl_nm)
	var laser_shdr := laser.material_override as ShaderMaterial
	laser_shdr.set_shader_parameter("laser_wvlth", _wvl_nm)

func _on_radius_changed(_rad_nm:float)->void:
	$CanvasLayer/UI/MarginContainer/VBoxContainer/grid/RadLbl.text = "%.1f"%_rad_nm
	# ---
	var mie_shdr := mie_scatt.material_override as ShaderMaterial
	mie_shdr.set_shader_parameter("rad_nw", _rad_nm)
	# ---
	var mesh := nw.mesh as CylinderMesh
	mesh.top_radius    = 0.1*_rad_nm/150.
	mesh.bottom_radius = 0.1*_rad_nm/150.

func _on_play_sweep()->void:
	var min_val = $CanvasLayer/UI/MarginContainer/VBoxContainer/HBoxContainer/MinVal.value
	var max_val = $CanvasLayer/UI/MarginContainer/VBoxContainer/HBoxContainer/MaxVal.value
	# ---
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR)
	var sweep_duration = $CanvasLayer/UI/MarginContainer/VBoxContainer/HBoxContainer2/SweepTime.value
	tween.tween_property($CanvasLayer/UI/MarginContainer/VBoxContainer/grid/wvl_val, "value", max_val, sweep_duration).from(min_val)
