extends Sprite2D

var time : float = 0.0
var speed : float = 1.5
var amplitude : float = 5.0
@onready var startPos : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if visible:
		if not startPos:
			startPos = position
		time += delta
		position = startPos + Vector2(0, sin(time * speed) * amplitude)
	else:
		startPos = Vector2.ZERO
