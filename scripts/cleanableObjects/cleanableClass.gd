extends Area2D
class_name Cleanable

func clean(stance : InteractionType.Stance) -> void:
	match stance: # match the value of stance to one of the listed values
		InteractionType.Stance.STANDING: # standing value
			start_standing_task()
		InteractionType.Stance.CROUCHING: # crouching value
			start_crouching_task()
		InteractionType.Stance.REACHING: # reaching value
			start_reaching_task()
		_: # default case
			print("error - something bad happened fix it")


# override whichever ones youre gonna use
func start_standing_task() -> void:
	# default behavior
	push_warning("standing task not implemented for " + self.name + ", intentional?")
	
func start_crouching_task() -> void:
	# default behavior
	push_warning("standing task not implemented for " + self.name + ", intentional?")

func start_reaching_task() -> void:
	# default behavior
	push_warning("standing task not implemented for " + self.name + ", intentional?")
