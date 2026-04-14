extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite2D

var gravity : int = 9.81 * 5000
var speed : int = 2 * 5000

var crouching : bool = false
var direction : int

func _physics_process(delta: float) -> void:
	if not self.is_on_floor():
		self.velocity.y += gravity * delta
	
	direction = Input.get_axis("left", "right")
	var finalVel = (direction * (speed)) / (1 + int(crouching))
	self.velocity.x = finalVel * delta
	
	crouching = Input.is_action_pressed("down")

	move_and_slide()

var crouchTexture = preload("res://player/crouch.png")
var standTexture = preload("res://player/stand.png")
func _process(delta: float) -> void:
	if direction == -1:
		sprite.flip_h = true
	elif direction == 1:
		sprite.flip_h = false
	
	if crouching:
		sprite.texture = crouchTexture
		sprite.offset = Vector2(0, 61)
	else:
		sprite.texture = standTexture
		sprite.offset = Vector2(0, 0)
		
