extends Node2D

var points : Array[Dictionary]
@onready var dirt_mask_texture : Texture2D = get_parent().get_parent().get_parent().get_node("dirt").material.get_shader_parameter("mask_texture")

func _ready() -> void:
	queue_redraw()

func draw_at(pos):
	points.append({"pos": pos, "radius": randi_range(30, 60)})
	queue_redraw()

func _draw():
	if dirt_mask_texture:
		draw_texture_rect(dirt_mask_texture, Rect2(Vector2.ZERO, get_parent().size), false)
	for p in points:
		draw_circle(p["pos"], p["radius"], Color.WHITE)
