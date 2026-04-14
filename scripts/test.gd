extends Node2D

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	
	var zoomOut = create_tween()
	zoomOut.tween_property($Camera2D, "zoom", Vector2(1, 1), 3)
