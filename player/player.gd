extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite2D
@onready var camera = $Camera2D

var currentStance : InteractionType.Stance = InteractionType.Stance.STANDING # default stance

var gravity : float = 9.81 * 5000
var speed : int = 2 * 5000
var crouching : bool = false
var reaching : bool = false
var direction : float
var alive : bool = true
var freezeMovement : bool = false

func _physics_process(delta: float) -> void:
	if (not alive) or freezeMovement: return
	
	# apply gravity
	if not self.is_on_floor():
		self.velocity.y += gravity * delta
	
	# movement direction
	direction = Input.get_axis("left", "right")
	var finalVel = (direction * (speed)) / (1 + float(crouching))
	self.velocity.x = finalVel * delta
	
	# crouching and reaching values
	crouching = Input.is_action_pressed("down")
	reaching = Input.is_action_pressed("up")
	
	# set current cleaning stance
	#currentStance = InteractionType.Stance.CROUCH if crouching else InteractionType.Stance.STAND
	# this above code was replaced since theres 3 stances and not 2
	if crouching:
		change_sprite("crouching")
		currentStance = InteractionType.Stance.CROUCHING
	elif reaching:
		change_sprite("reaching")
		currentStance = InteractionType.Stance.REACHING
	else:
		change_sprite("standing")
		currentStance = InteractionType.Stance.STANDING

	move_and_slide()

var crouchingTexture = preload("res://player/RoombaF.png")
var standingTexture = preload("res://player/RoombaS.png")
func _process(_delta: float) -> void:
	if (not alive) or freezeMovement: return
	
	if direction == -1:
		sprite.flip_h = true
	elif direction == 1:
		sprite.flip_h = false

func change_sprite(newSpriteName) -> void:
	match newSpriteName.to_lower():
		"crouching":
			sprite.texture = crouchingTexture
		"standing":
			sprite.texture = standingTexture
		#"Reaching":
			#sprite.texture = crouchTexture

func get_stance() -> InteractionType.Stance:
	return currentStance

func die() -> void:
	self.alive = false

func can_move(canMove : bool) -> void:
	freezeMovement = not canMove
	
	# zoom camera in
	var newZoom = 6.0
	var zoomIn = create_tween()
	zoomIn.set_ease(Tween.EASE_OUT)
	zoomIn.set_trans(Tween.TRANS_QUART)
	if not canMove:
		newZoom = 6.0
	else:
		newZoom = 2.0
	zoomIn.tween_property(camera, "zoom", Vector2(newZoom, newZoom), 1.0)
