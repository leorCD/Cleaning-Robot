extends CharacterBody2D
class_name Player

@onready var sprite = $Sprite2D
@onready var camera = $Camera2D

var movementState : States.MovementState = States.MovementState.STAND # default State
var actionState : States.ActionState = States.ActionState.NONE # default State

var gravity : float = 9.81 * 100
var direction : float
var speed : int = 2 * 5000

var crouching : bool = false
var reaching : bool = false

var alive : bool = true
var freezeMovement : bool = false
var forceFreeze : bool = false



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
		movementState = States.MovementState.CROUCH
	elif reaching:
		movementState = States.MovementState.REACH
	elif direction:
		movementState = States.MovementState.WALK
	else:
		movementState = States.MovementState.STAND
	
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
	movementState = States.MovementState.DEAD
	
	await get_tree().create_timer(1).timeout
	SceneTransition.restart_scene()

func can_move(canMove : bool) -> void:
	if forceFreeze:
		freezeMovement = true
		zoom_camera(1.8)
		return
	
	freezeMovement = not canMove
	if not canMove:
		zoom_camera(6.0)
	else:
		zoom_camera(2.5)

func zoom_camera(zoom : float) -> void:
	camera.position = Vector2.ZERO
	
	var zoomIn = create_tween()
	zoomIn.set_ease(Tween.EASE_OUT)
	zoomIn.set_trans(Tween.TRANS_QUART)
	zoomIn.tween_property(camera, "zoom", Vector2(zoom, zoom), 1.0)
