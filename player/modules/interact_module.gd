extends Area2D
class_name InteractionModule

@onready var player : Player = self.get_parent()
@export var TaskHud : CanvasLayer = null

var nearbyInteractables : Array[Node] = []
var targetInteractable : Node = null
var isBusy : bool = false
var currentTask : Cleanable = null
var taskUI : Node = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if currentTask:
			end_task()
		isBusy = false
	
	if isBusy: return # everything past this point cannot be reached if alraedy interacting
	
	if event.is_action_pressed("up") and (not isBusy):
		if not (targetInteractable and targetInteractable is Interactable):
			return # if no interactable and target isn't an interactable
		if isBusy:
			return
			
		isBusy = true
		await targetInteractable.interact(player)
		isBusy = false
	
	if event.is_action_pressed("spacebar"):
		if isBusy:
			return
		if start_task():
			isBusy = true
		


# start and end tasks
func start_task() -> bool:
	if not (targetInteractable and targetInteractable is Cleanable):
		return false # if there isn't any object to interact with
	if currentTask:
		return false # if they're already doing a task
	
	var movementState = player.movementState
	
	currentTask = targetInteractable
	taskUI = currentTask.start_task(movementState)
	
	$TaskLayer.add_child(taskUI)
	taskUI.position.y = taskUI.size.y
	var TweenIn = create_tween()
	TweenIn.set_trans(Tween.TRANS_QUART)
	TweenIn.set_ease(Tween.EASE_OUT)
	TweenIn.tween_property(taskUI, "position:y", 0.0, 1.0)
	
	player.can_move(false)
	return true

func end_task() -> void:
	if not currentTask:
		return
	
	currentTask.end_task()
	currentTask = null
	
	var TweenOut = create_tween()
	TweenOut.set_trans(Tween.TRANS_QUART)
	TweenOut.tween_property(taskUI, "position:y", taskUI.size.y, 1.0)
	player.can_move(true)



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
