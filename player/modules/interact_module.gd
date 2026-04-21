extends Area2D
class_name InteractionModule

var levelAnalysisScene : PackedScene = load("res://scenes/level_complete_screen.tscn")

@onready var player : Player = self.get_parent()
@export var TaskHud : CanvasLayer = null
@export var HUDModule : CanvasLayer = null

var nearbyInteractables : Array[Node] = []
var targetInteractable : Node = null
var isBusy : bool = false
var currentTask : Cleanable = null
var taskUI : Node = null

@onready var objectMarker : Node2D = load("res://scenes/object_marker.tscn").instantiate()

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
	
	taskUI = targetInteractable.start_task(self, movementState)
	if not taskUI:
		return false
		
	currentTask = targetInteractable
	if currentTask.activeTask:
		currentTask.activeTask.task_finished.connect(func():
			isBusy = false  
		)
	if targetInteractable.get_parent() is TaskManager:
		var taskmanager = targetInteractable.get_parent()
		
		if not taskmanager.level_complete.is_connected(on_level_complete):
			taskmanager.level_complete.connect(on_level_complete)
	
	player.can_move(false)
	tween_task()
	
	return true

func tween_task() -> void:
	$TaskLayer.add_child(taskUI)
	taskUI.get_node("Canvas/Panel").self_modulate.a = 1.0
	taskUI.get_node("Canvas/Panel/Label").visible = true
	taskUI.get_node("Canvas/Panel/MarginContainer").visible = false
	$TaskLayer/TranslucentLayer.visible = true
	
	
		# darken everything else
	var TweenLayerIn = create_tween()
	TweenLayerIn.tween_property($TaskLayer/TranslucentLayer, "modulate:a", 0.8, 0.5)
	
		# tween into center
	taskUI.position.y = taskUI.size.y
	var TweenTaskIn = create_tween()
	TweenTaskIn.set_trans(Tween.TRANS_QUART)
	TweenTaskIn.set_ease(Tween.EASE_OUT)
	TweenTaskIn.tween_property(taskUI, "position:y", 0.0, 1.0)

	# after tween into center finishes
	await TweenTaskIn.finished
	if not taskUI:
		return
	taskUI.get_node("Canvas/Panel/Label").text = "FEED ONLINE"
	
	# after 0.5 seconds
	await get_tree().create_timer(0.5).timeout
	if not taskUI:
		return
		
		# disable black screen
	var DisableBlack = create_tween()
	DisableBlack.set_trans(Tween.TRANS_QUART)
	DisableBlack.tween_property(taskUI.get_node("Canvas/Panel"), "self_modulate:a", 0.0, 0.1)
	taskUI.get_node("Canvas/Panel/Label").visible = false
		# show task
	taskUI.get_node("Canvas/Panel/MarginContainer").visible = true
		# disable loading text
	taskUI.get_node("Canvas/Panel/Label").visible = false



func end_task() -> void:
	if not currentTask:
		return
	
	player.can_move(true)
	currentTask.end_task()
	currentTask = null
	
	if not taskUI:
		return
	
	var TweenTaskOut = create_tween()
	TweenTaskOut.set_trans(Tween.TRANS_QUART)
	TweenTaskOut.tween_property(taskUI, "position:y", taskUI.size.y, 1.0)
	taskUI.queue_free()
	taskUI = null
	
	var TweenLayerIn = create_tween()
	TweenLayerIn.tween_property($TaskLayer/TranslucentLayer, "modulate:a", 0.0, 0.5)
	await TweenLayerIn.finished
	$TaskLayer/TranslucentLayer.visible = false

func on_level_complete() -> void:
	player.forceFreeze = true
	
	var levelAnalysis = levelAnalysisScene.instantiate()
	$LevelComplete.add_child(levelAnalysis)
	levelAnalysis.global_position.y = 700
	
	var tweenIntoScreen = create_tween() \
	.set_trans(Tween.TRANS_QUART) \
	.tween_property(levelAnalysis, "global_position:y", 0, 1.0)



# store objects colliding with player
func _on_area_entered(newArea: Area2D) -> void:
	if (not newArea in nearbyInteractables):
		nearbyInteractables.append(newArea)
		update_closest_interactable()
		
func _on_area_exited(newArea: Area2D) -> void:
	if (newArea in nearbyInteractables):
		nearbyInteractables.erase(newArea)
		update_closest_interactable()
	
	if not targetInteractable:
		objectMarker.visible = false

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
	
	if closest and (closest is Interactable or closest is Cleanable):
		objectMarker.visible = true
		if objectMarker.get_parent() == closest:
			return
		if objectMarker.get_parent() == null:
			closest.add_child(objectMarker)
		
		objectMarker.reparent(closest)
		var closestObjectSizeY = Vector2(0, -closest.get_node("CollisionShape2D").shape.size.y * 3/4)
		objectMarker.global_position = closest.global_position + closestObjectSizeY
	
	targetInteractable = closest
