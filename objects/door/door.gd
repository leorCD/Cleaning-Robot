extends Area2D
class_name Door

@export var leadsTo : Door = null


@onready var openTexture : Texture2D = load("res://objects/door/DoorOpen.png")
@onready var closeTexture : Texture2D = load("res://objects/door/DoorClose.png")
func interact(player : Player) -> void:
	if not leadsTo: return
	
	change_texture(openTexture)
	await fade_player_out(player)
	change_texture(closeTexture)
	
	leadsTo.change_texture(openTexture)
	
	player.global_position = leadsTo.global_position
	
	await fade_player_in(player)
	leadsTo.change_texture(closeTexture)

func change_texture(texture : Texture2D) -> void:
	$DoorSprite.texture = texture


func fade_player_out(player: Player) -> void:
	player.can_move(false)
	
	var fadeAway = create_tween()
	fadeAway.tween_property(player, "modulate:a", 0.0, 1.0)
	
	await fadeAway.finished
	

func fade_player_in(player: Player) -> void:
	var fadeIn = create_tween()
	fadeIn.tween_property(player, "modulate:a", 1.0, 1.0)
	
	await fadeIn.finished
	player.can_move(true)
