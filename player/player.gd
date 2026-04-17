extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite2D
@onready var camera = $Camera2D

signal state_changed
var movementState : States.MovementState = States.MovementState.STANDING # default State
var actionState : States.ActionState = States.ActionState.NONE # default State

var gravity : float = 9.81 * 100
var direction : float
var speed : int = 2 * 5000
var crouching : bool = false
var reaching : bool = false
var alive : bool = true
var freezeMovement : bool = false



func _ready() -> void:
	randomize() # essentially resets the generator seed, otherwise randf would give the same random number every time
	
	var h = randf()                     # any hue
	var s = randf_range(0.4, 0.8)       # avoid gray (0.0) or neon (1.0)
	var v = randf_range(0.5, 0.9)       # avoid too dark (0.0) and too bright (1.0)
	var hsvColor = Color.from_hsv(h, s, v)
	
	var colorShader : ShaderMaterial = sprite.material
	colorShader.set_shader_parameter("newColor", hsvColor)

func _physics_process(delta: float) -> void:
	if (not alive):
		return
	if freezeMovement:
		return
	
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
	
	# set current movement state (for cleaning tasks)
	if crouching:
		movementState = States.MovementState.CROUCHING
		camera.position.y = 15
	elif reaching:
		movementState = States.MovementState.REACHING
		camera.position.y = -15
	else:
		movementState = States.MovementState.STANDING
		camera.position.y = 0
	
	move_and_slide()

func _process(_delta: float) -> void:
	if (not alive) or freezeMovement:
		return
	
	if direction == -1:
		sprite.flip_h = true
	elif direction == 1:
		sprite.flip_h = false



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
	camera.position = Vector2.ZERO
	zoomIn.tween_property(camera, "zoom", Vector2(newZoom, newZoom), 1.0)
