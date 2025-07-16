extends Label

func _process(delta: float) -> void:
	text = "fps: %.f"%Engine.get_frames_per_second()
