extends Control

var pressed = false
var grid : float = 16.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed = event.is_pressed()

func _process(_delta: float) -> void:
	if pressed:
		var container = $Canvas/SubViewportContainer
		var pos = container.get_local_mouse_position()
		
		# snap to grid
		pos = (pos / grid).floor() * grid
		
		container.get_node("SubViewport/drawing").draw_at(pos)
		update_mask()

func update_mask() -> void:
	await RenderingServer.frame_post_draw
	var texture = $Canvas/SubViewportContainer/SubViewport.get_texture()
	$Canvas/dirt.material.set_shader_parameter("mask_texture", texture)
