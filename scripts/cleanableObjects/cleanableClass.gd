extends Area2D
class_name Cleanable

@export_category("Tasks")
@export var StandingTaskScene : PackedScene = null
@export var CrouchingTaskScene : PackedScene = null
@export var ReachingTaskScene : PackedScene = null
var active_task : Node = null

func start_task(stance : InteractionType.Stance) -> Node:
	var task_scene : PackedScene = null
	
	match stance: # match the value of stance to one of the listed values
		InteractionType.Stance.STANDING: # standing value
			task_scene = StandingTaskScene
			#start_standing_task()
		InteractionType.Stance.CROUCHING: # crouching value
			task_scene = CrouchingTaskScene
			#start_crouching_task()
		InteractionType.Stance.REACHING: # reaching value
			task_scene = ReachingTaskScene
			#start_reaching_task()
		_: # default case
			print("error - something bad happened fix it")
	
	if task_scene == null:
		push_warning("no task assigned for " + InteractionType.Stance.keys()[stance] + " on " + name)
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
