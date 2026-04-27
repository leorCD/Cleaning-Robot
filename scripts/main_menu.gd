extends Control

@export var playButton : Button = null
@export var settingsButton : Button = null
@export var exitButton : Button = null

func _ready() -> void:
	# ready is automatically called right when the script is loaded into the scene
	
	# connect each button to their functions
	playButton.pressed.connect(play_function)
	settingsButton.pressed.connect(settings_function)
	exitButton.pressed.connect(exit_function)



func play_function() -> void:
	SceneTransition.change_scenes("res://scenes/level1.tscn")
	
func settings_function() -> void:
	print("open settings")
	
func exit_function() -> void:
	pass
