extends Interactable
class_name LevelEnd

@export var taskManager : TaskManager = null

var levelEnded : bool = false
var levelAnalysisScene : PackedScene = load("res://scenes/level_complete_screen.tscn")

func interact(player : Player) -> void:
	if levelEnded:
		return
	levelEnded = true
	
	player.forceFreeze = true
	player.can_move(false)
	
	var levelAnalysis = levelAnalysisScene.instantiate()
	$LevelComplete.add_child(levelAnalysis)
	levelAnalysis.global_position.y = 700
	
	var tweenIntoScreen = create_tween() \
	.set_trans(Tween.TRANS_QUART)
	tweenIntoScreen.tween_property(levelAnalysis, "global_position:y", 0, 1.0)
	
	var remainingBattery = player.get_node("BatteryModule").currBattery
	var missedTasks = (taskManager.totalCleanables - taskManager.completedCleanables)
	print("remaining battery : " + str(remainingBattery))
	print("missed tasks : " + str(missedTasks))
