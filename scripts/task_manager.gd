extends Node
class_name TaskManager

signal level_complete
var totalCleanables : int = 0

func _ready() -> void:
	await get_tree().process_frame
	
	for task in self.get_children():
		if not (task is Cleanable):
			continue
		task.task_completed.connect(on_cleanable_task_finished)
		
		if task.StandingTaskScene:
			totalCleanables += 1
		if task.CrouchingTaskScene:
			totalCleanables += 1
		if task.ReachingTaskScene:
			totalCleanables += 1
	#print("total objectives : ", totalCleanables)

func on_cleanable_task_finished() -> void:
	if totalCleanables > 1:
		totalCleanables -= 1
	else:
		level_finish()

func level_finish() -> void:
	#print("all tasks fisihed")
	level_complete.emit()
