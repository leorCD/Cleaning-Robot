extends Area2D
class_name Cleanable

@export_category("Tasks")
@export var StandingTaskScene : PackedScene = null
var standingTaskFinished : bool = true
@export var CrouchingTaskScene : PackedScene = null
var crouchingTaskFinished : bool = true
@export var ReachingTaskScene : PackedScene = null
var reachingTaskFinished : bool = true

var activeTask : Node = null
var currentState : States.MovementState = States.MovementState.NONE

func _ready() -> void:
	if StandingTaskScene: standingTaskFinished = false
	if CrouchingTaskScene: crouchingTaskFinished = false
	if ReachingTaskScene: reachingTaskFinished = false

func start_task(State : States.MovementState) -> Node:
	var task_scene : PackedScene = null
	currentState = State
	
	match State: # match the value of State to one of the listed values
		States.MovementState.STANDING: # standing value
			if standingTaskFinished: return null
			task_scene = StandingTaskScene
			
		States.MovementState.CROUCHING: # crouching value
			if crouchingTaskFinished: return null
			task_scene = CrouchingTaskScene
			
		States.MovementState.REACHING: # reaching value
			if reachingTaskFinished: return null
			task_scene = ReachingTaskScene
			
		_: # default case
			print("task start error - something bad happened fix it")
	
	if task_scene == null:
		push_warning("no task assigned for " + States.MovementState.keys()[State] + " on " + name)
		return null
	
	activeTask = task_scene.instantiate()
	if activeTask.has_signal("task_finished"):
		activeTask.task_finished.connect(on_task_finished)
	
	return activeTask

func end_task() -> void:
	if activeTask:
		if activeTask.has_signal("task_finished") and activeTask.task_finished.is_connected(on_task_finished):
			activeTask.task_finished.disconnect(on_task_finished)
			
			activeTask.get_node("TaskFinishText").visible = true
			
		activeTask = null



func on_task_finished() -> void:
	match currentState:
		States.MovementState.STANDING:
			standingTaskFinished = true
			print("standing finished")
			
		States.MovementState.CROUCHING:
			crouchingTaskFinished = true
			print("crouching finished")
			
		States.MovementState.REACHING:
			reachingTaskFinished = true
			print("reaching finished")
			
		_:
			print("task finish error - something bad happened fix it")
	
	end_task()
