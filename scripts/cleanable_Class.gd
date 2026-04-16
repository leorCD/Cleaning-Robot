extends Area2D
class_name Cleanable

@export_category("Tasks")
@export var StandingTaskScene : PackedScene = null
@export var CrouchingTaskScene : PackedScene = null
@export var ReachingTaskScene : PackedScene = null
var active_task : Node = null

func start_task(State : States.MovementState) -> Node:
	var task_scene : PackedScene = null
	
	match State: # match the value of State to one of the listed values
		States.MovementState.STANDING: # standing value
			task_scene = StandingTaskScene
			#start_standing_task()
		States.MovementState.CROUCHING: # crouching value
			task_scene = CrouchingTaskScene
			#start_crouching_task()
		States.MovementState.REACHING: # reaching value
			task_scene = ReachingTaskScene
			#start_reaching_task()
		_: # default case
			print("error - something bad happened fix it")
	
	if task_scene == null:
		push_warning("no task assigned for " + States.MovementState.keys()[State] + " on " + name)
		return
	
	active_task = task_scene.instantiate()
	return active_task

func end_task() -> void:
	pass



# override whichever ones youre gonna use
#func start_standing_task() -> void:
	## default behavior
	#if StandingTask == null:
		#push_warning("standing task not implemented for " + self.name + ", intentional?")
	#
#func start_crouching_task() -> void:
	## default behavior
	#if ReachingTask == null:
		#push_warning("standing task not implemented for " + self.name + ", intentional?")
#
#func start_reaching_task() -> void:
	## default behavior
	#if StandingTask == null:
		#push_warning("standing task not implemented for " + self.name + ", intentional?")
