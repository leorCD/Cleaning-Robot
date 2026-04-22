extends Control
class_name CleaningTask

signal task_finished

@onready var background = $Canvas/Panel/MarginContainer/background
@onready var dirt = $Canvas/Panel/MarginContainer/dirt
@onready var svContainer = $Canvas/Panel/MarginContainer/SubViewportContainer
@onready var subViewport = $Canvas/Panel/MarginContainer/SubViewportContainer/SubViewport

var mousePressed : bool = false
var _mask_img : Image
var _dirt_img : Image

func _ready() -> void:
	await RenderingServer.frame_post_draw
	dirt.material.set_shader_parameter("brush_texture", subViewport.get_texture())
	_dirt_img = dirt.texture.get_image()
	
	_mask_img = generate_mask()
	var mask_tex = ImageTexture.create_from_image(_mask_img)
	dirt.material.set_shader_parameter("mask_texture", mask_tex)

func generate_mask() -> Image:
	# generate mask from dirt texture
	var mask = Image.create(_dirt_img.get_width(), _dirt_img.get_height(), false, Image.FORMAT_RGBA8)
	
	for x in range(_dirt_img.get_width()):
		for y in range(_dirt_img.get_height()):
			var pixel = _dirt_img.get_pixel(x, y)
			if pixel.a > 0.1:
				mask.set_pixel(x, y, Color.BLACK)
			else:
				mask.set_pixel(x, y, Color.WHITE)
	return mask

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mousePressed = event.is_pressed()

func _process(_delta: float) -> void:
	if mousePressed:
		var pos = svContainer.get_local_mouse_position()
		
		svContainer.get_node("SubViewport/drawing").draw_at(pos)
		update_mask()



func update_mask() -> void:
	await RenderingServer.frame_post_draw
	if get_clean_percent() >= 0.95:
		task_finished.emit()

func get_clean_percent() -> float:
	var img: Image = subViewport.get_texture().get_image()
	var step = 12
	var total := 0
	var cleaned := 0

	for x in range(0, _mask_img.get_width(), step):
		for y in range(0, _mask_img.get_height(), step):
			if _mask_img.get_pixel(x, y).r < 0.9 and _dirt_img.get_pixel(x, y).a > 0.1:  # dirt pixel that's actually visible
				total += 1
				# map mask coords to brush coords
				var bx = int(float(x) / _mask_img.get_width() * img.get_width())
				var by = int(float(y) / _mask_img.get_height() * img.get_height())
				if img.get_pixel(bx, by).r > 0.5:
					cleaned += 1

	#print("")
	#print("=====================")
	#print("")
	#print("cleaned: ", cleaned, " / ", total, " = ", float(cleaned) / float(total) if total > 0 else 1.0)
	#print("subViewport size: ", subViewport.size)
	#print("mask size: ", Vector2(_mask_img.get_width(), _mask_img.get_height()))
	#print("brush image size: ", img.get_width(), "x", img.get_height())

	if total == 0:
		return 1.0
	return float(cleaned) / float(total)
