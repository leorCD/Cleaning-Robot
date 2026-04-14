extends Control

func change_scenes(scene_path : String) -> void:
	await close()
	get_tree().change_scene_to_file(scene_path)
	await open()

func close() -> void:
	$AnimationPlayer.play("Fade in")
	await $AnimationPlayer.animation_finished

func open() -> void:
	$AnimationPlayer.play("Fade out")
	await $AnimationPlayer.animation_finished
