extends Area2D
class_name InteractionModule

@onready var parent : Player = self.get_parent()
@export var HUD : CanvasLayer = null

var nearbyInteractables : Array[Cleanable] = []
var targetInteractable : Cleanable = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if not targetInteractable: return
		
		var currentStance = parent.get_stance()
		targetInteractable.clean(currentStance)
		
		HUD.set_interaction_text("Cleaning " + str(InteractionType.Stance.keys()[currentStance]))



# store objects colliding with player
func _on_area_entered(newArea: Area2D) -> void:
	if (not newArea in nearbyInteractables) and (newArea is Cleanable):
		nearbyInteractables.append(newArea)
		update_closest_interactable()
		
func _on_area_exited(newArea: Area2D) -> void:
	if (newArea in nearbyInteractables) and (newArea is Cleanable):
		nearbyInteractables.erase(newArea)
		update_closest_interactable()

func update_closest_interactable() -> void:
	var closest : Cleanable = null
	var closestDistance : float = INF
	
	for object in nearbyInteractables:
		if not is_instance_valid(object): # confirms the object still exists if it disappears somehow
			continue # move onto the next iteration
		
		var distance = self.global_position.distance_to(object.global_position)
		
		if distance < closestDistance: # if the object is closer
			closestDistance = distance # set its distance as the new threshold
			closest = object # set it as the new closest object
		
	targetInteractable = closest
	
	if targetInteractable == null:
		HUD.set_interaction_text("")
	else:
		HUD.set_interaction_text("Press 'space' to clean " + str(targetInteractable.name))
