extends Node2D

var drawPosition : Vector2 = Vector2.ZERO

func _draw() -> void:
	if drawPosition == Vector2.ZERO:
		return
	
	self.draw_circle(
		drawPosition, # position
		randi_range(40, 60), # radius
		Color.WHITE # color
	)

func draw_at(pos : Vector2) -> void:
	if drawPosition == pos:
		return
	drawPosition = pos
	queue_redraw()
