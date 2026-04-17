extends Node2D

var drawPosition : Vector2 = Vector2.ZERO

func _draw() -> void:
	if drawPosition == Vector2.ZERO:
		return
	
	self.draw_rect(
		Rect2(drawPosition, Vector2(40, 40)),
		Color(1, 1, 1, 1),
		true
	)

func draw_at(pos : Vector2) -> void:
	drawPosition = pos
	queue_redraw()
