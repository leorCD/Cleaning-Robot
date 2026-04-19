extends Area2D
class_name Cleanable

@export_category("Tasks")
@export var StandingTaskScene : PackedScene = null
var standingTaskFinished : bool = true
@export var CrouchingTaskScene : PackedScene = null
var crouchingTaskFinished : bool = true
@export var ReachingTaskScene : PackedScene = null
var reachingTaskFinished : bool = true

@onready var sprite : Sprite2D = $Sprite2D
var activeTask : Control = null
var currentState : States.MovementState = States.MovementState.NONE
var interactor : InteractionModule = null

func _ready() -> void:
	if StandingTaskScene: standingTaskFinished = false
	if CrouchingTaskScene: crouchingTaskFinished = false
	if ReachingTaskScene: reachingTaskFinished = false

func start_task(calledBy : InteractionModule, State : States.MovementState) -> Node:
	interactor = calledBy
	var task_scene : PackedScene = null
	currentState = State
	
	match State: # match the value of State to one of the listed values
		States.MovementState.STAND: # standing value
			if standingTaskFinished: return null
			task_scene = StandingTaskScene
			
		States.MovementState.CROUCH: # crouching value
			if crouchingTaskFinished: return null
			task_scene = CrouchingTaskScene
			
		States.MovementState.REACH: # reaching value
			if reachingTaskFinished: return null
			task_scene = ReachingTaskScene
			
		_: # default case
			print("task start error - something bad happened fix it")
	
	if task_scene == null:
		#push_warning("no task assigned for " + States.MovementState.keys()[State] + " on " + name)
		return null
	
	activeTask = task_scene.instantiate()
	if activeTask.has_signal("task_finished"):
		activeTask.task_finished.connect(on_task_finished)
	
	return activeTask

func end_task() -> void:
	if activeTask:
		if activeTask.has_signal("task_finished") and activeTask.task_finished.is_connected(on_task_finished):
			activeTask.task_finished.disconnect(on_task_finished)
			
			activeTask.get_node("Canvas").z_index = -1
			interactor.end_task()
			
		activeTask = null
		interactor = null



func on_task_finished() -> void:
	match currentState:
		States.MovementState.STAND:
			standingTaskFinished = true
			#print("standing finished")
			
		States.MovementState.CROUCH:
			crouchingTaskFinished = true
			#print("crouching finished")
			
		States.MovementState.REACH:
			reachingTaskFinished = true
			#print("reaching finished")
			
		_:
			print("task finish error - something bad happened fix it")
	
	end_task()
	
	# blink animation
	await get_tree().create_timer(0.65).timeout
	sprite.material.set_shader_parameter("flash", 1.0)
	var baseSizeY = sprite.scale.y
	sprite.scale.y *= 0.9
	sprite.offset.y = 40
	
		# animation
	var blinkTween = create_tween().parallel()
	blinkTween.set_trans(Tween.TRANS_EXPO)
	blinkTween.set_ease(Tween.EASE_OUT)
	blinkTween.parallel().tween_property(sprite.material, "shader_parameter/flash", 0.0, 0.6)
	blinkTween.parallel().tween_property(sprite, "scale:y", baseSizeY, 0.4)
	blinkTween.parallel().tween_property(sprite, "offset:y", 0, 0.4)
	
