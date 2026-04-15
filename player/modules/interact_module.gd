extends Area2D
class_name InteractionModule

@onready var parent : Player = self.get_parent()
@export var TaskHud : CanvasLayer = null

var nearbyInteractables : Array[Node] = []
var targetInteractable : Node = null
var currentTask : Cleanable = null
var taskUI : Node = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		if not targetInteractable: return
		targetInteractable.interact(parent)
	
	if event.is_action_pressed("interact"):
		start_task()
		
	if event.is_action_pressed("escape"):
		end_task()


# start and end tasks
func start_task() -> void:
	if not targetInteractable: return
	if currentTask: return
	
	var currentStance = parent.get_stance()
	
	currentTask = targetInteractable
	taskUI = currentTask.start_task(currentStance)
	
	$TaskLayer.add_child(taskUI)
	taskUI.position.y = taskUI.size.y
	var TweenIn = create_tween()
	TweenIn.set_trans(Tween.TRANS_QUART)
	TweenIn.set_ease(Tween.EASE_OUT)
	TweenIn.tween_property(taskUI, "position:y", 0.0, 1.0)
	
	parent.can_move(false)

func end_task() -> void:
	if currentTask:
		currentTask.end_task()
		currentTask = null
		
		var TweenOut = create_tween()
		TweenOut.set_trans(Tween.TRANS_QUART)
		TweenOut.tween_property(taskUI, "position:y", taskUI.size.y, 1.0)
	parent.can_move(true)



# store objects colliding with player
func _on_area_entered(newArea: Area2D) -> void:
	if (not newArea in nearbyInteractables):
		nearbyInteractables.append(newArea)
		update_closest_interactable()
		
func _on_area_exited(newArea: Area2D) -> void:
	if (newArea in nearbyInteractables):
		nearbyInteractables.erase(newArea)
		update_closest_interactable()

func update_closest_interactable() -> void:
	var closest : Node = null
	var closestDistance : float = INF
	
	for object in nearbyInteractables:
		if not is_instance_valid(object): # confirms the object still exists if it disappears somehow
			continue # move onto the next iteration
		
		var distance = self.global_position.distance_to(object.global_position)
		
		if distance < closestDistance: # if the object is closer
			closestDistance = distance # set its distance as the new threshold
			closest = object # set it as the new closest object
		
	targetInteractable = closest
