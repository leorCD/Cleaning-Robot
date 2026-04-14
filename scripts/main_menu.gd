extends Control

@export var playButton : Button = null
@export var settingsButton : Button = null
@export var exitButton : Button = null

func _ready() -> void:
	# ready is automatically called right when the script is loaded into the scene
	
	# connect each button to their functions
	playButton.pressed.connect(playFunction)
	settingsButton.pressed.connect(settingsFunction)
	exitButton.pressed.connect(exitFunction)



func playFunction() -> void:
	SceneTransition.change_scenes("res://scenes/level1.tscn")
	
func settingsFunction() -> void:
	print("open settings")
	
func exitFunction() -> void:
	pass
