extends Control

var fakeAspectRatio : PackedScene = preload("res://global/4_3_fake_aspect_ratio.tscn")
var existing = null

func change_scenes(scene_path : String) -> void:
	await close()
	
	
	get_tree().change_scene_to_file(scene_path)
	
	#existing = create_fake_aspect_ratio()
	#get_tree().root.add_child(existing)
	
	await open()

func create_fake_aspect_ratio() -> Node:
	if existing:
		return existing
	
	var newFake = fakeAspectRatio.instantiate()
	return newFake

func close() -> void:
	$AnimationPlayer.play("Fade in")
	await $AnimationPlayer.animation_finished

func open() -> void:
	$AnimationPlayer.play("Fade out")
	await $AnimationPlayer.animation_finished
