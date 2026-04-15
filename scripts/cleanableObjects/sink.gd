extends Area2D
class_name Cleanable

func clean(stance : InteractionType.Stance) -> void:
	match stance: # match the value of stance to one of the listed values
		InteractionType.Stance.NONE: # no value
			print("error")
		InteractionType.Stance.STAND: # standing value
			print("stand")
		InteractionType.Stance.CROUCH: # crouching value
			print("crouch")
		InteractionType.Stance.REACHING: # reaching value
			print("reaching")
