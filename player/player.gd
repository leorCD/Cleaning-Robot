extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite2D

var currentStance : InteractionType.Stance = InteractionType.Stance.STANDING # default stance

var gravity : float = 9.81 * 5000
var speed : int = 2 * 5000
var crouching : bool = false
var reaching : bool = false
var direction : float
var alive : bool = true

func _physics_process(delta: float) -> void:
	if not alive: return
	
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
		currentStance = InteractionType.Stance.CROUCHING
	elif reaching:
		currentStance = InteractionType.Stance.REACHING
	else:
		currentStance = InteractionType.Stance.STANDING

	move_and_slide()

var crouchTexture = preload("res://player/crouch.png")
var standTexture = preload("res://player/stand.png")
func _process(_delta: float) -> void:
	if not alive: return
	
	if direction == -1:
		sprite.flip_h = true
	elif direction == 1:
		sprite.flip_h = false
	
	if crouching:
		sprite.texture = crouchTexture
		sprite.offset = Vector2(0, 61)
	elif reaching:
		#sprite.texture = reachTexture # we dont have one yet
		sprite.offset = Vector2(0, -60)
	else:
		sprite.texture = standTexture
		sprite.offset = Vector2(0, 0)

func get_stance() -> InteractionType.Stance:
	return currentStance
	
func die() -> void:
	self.alive = false
