@tool
extends OmniLight3D


@onready var sub_viewport: SubViewport = $SubViewport
@onready var color_rect  : ColorRect = $SubViewport/ColorRect


@export_tool_button("Init txtr") var action = init_txtr
@export_tool_button("set img") var process_action = set_img_txtr
@export_range(350., 850., 0.1) var mie_wvlth :float= 632.:
	set(value):
		mie_wvlth=value
		if color_rect:
			var txtr_shdr = color_rect.material as ShaderMaterial
			txtr_shdr.set_shader_parameter("wvlth1_nm", mie_wvlth)
			await set_img_txtr()
@export_range(50., 500., 0.1) var nw_rad :float= 150.:
	set(value):
		nw_rad=value
		if color_rect:
			var txtr_shdr = color_rect.material as ShaderMaterial
			txtr_shdr.set_shader_parameter("rad_nw", nw_rad)
			await set_img_txtr()

var projector_txtr :ImageTexture
var img :Image

func _ready() -> void:
	init_txtr()
	set_process(true)

func init_txtr()->void:
	img = sub_viewport.get_texture().get_image() as Image
	#await get_subviewport_image(img)
	projector_txtr  = ImageTexture.create_from_image(img)
	light_projector = projector_txtr
	return

func set_img_txtr()->void:
	if not projector_txtr:
		return
	await get_subviewport_image(img)
	projector_txtr.set_image(img)


func get_subviewport_image(img:Image)->void:
	#sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var txtr := sub_viewport.get_texture()
	img.copy_from(txtr.get_image() as Image)
