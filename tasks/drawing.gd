extends Control

signal task_finished

@onready var dirt = $Canvas/MarginContainer/dirt
@onready var svContainer = $Canvas/MarginContainer/SubViewportContainer
@onready var subViewport = $Canvas/MarginContainer/SubViewportContainer/SubViewport

var mousePressed = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mousePressed = event.is_pressed()

func _process(_delta: float) -> void:
	if mousePressed:
		var container = svContainer
		var pos = container.get_local_mouse_position()
		
		container.get_node("SubViewport/drawing").draw_at(pos)
		update_mask()



func update_mask() -> void:
	await RenderingServer.frame_post_draw
	var texture = subViewport.get_texture()
	dirt.material.set_shader_parameter("mask_texture", texture)
	
	if get_clean_percent() >= 0.95:
		task_finished.emit()

func get_clean_percent() -> float:
	var vp = subViewport
	var img: Image = vp.get_texture().get_image()
	
	var width = img.get_width()
	var height = img.get_height()
	
	var step = 12  # ← sampling resolution (higher = performance, lower = quality)
	
	var total : int = 0
	var cleanedPercentage : int = 0
	
	for x in range(0, width, step):
		for y in range(0, height, step):
			total += 1
			
			var pixel = img.get_pixel(x, y)
			if pixel.r == 1.0:
				cleanedPercentage += 1
	
	return float(cleanedPercentage) / float(total)
