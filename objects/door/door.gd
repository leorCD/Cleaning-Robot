extends Interactable
class_name Door

@export var leadsTo : Door = null
@onready var openTexture : Texture2D = load("res://objects/door/DoorOpen.png")
@onready var closeTexture : Texture2D = load("res://objects/door/DoorClose.png")

var isTransitioning : bool = false
func interact(player : Player) -> void:
	if not leadsTo:
		return
	if isTransitioning:
		return
		
	isTransitioning = true
	await enter_door(player)
	isTransitioning = false

func place_player(player) -> void:
	var bottomOfDoor = leadsTo.global_position + Vector2(0, (leadsTo.get_node("CollisionShape2D").shape.size.y / 2))
	var playerHeight = -Vector2(0, player.get_node("CollisionShape2D").shape.size.y / 2)
	player.global_position = bottomOfDoor + playerHeight

func change_texture(texture : Texture2D) -> void:
	$DoorSprite.texture = texture

func enter_door(player: Player) -> void:
	change_texture(openTexture)
	
	player.can_move(false)
	player.actionState = States.ActionState.DOOR_ENTER
	
	player.modulate.a = 1.0
	var fadeAway = create_tween()
	fadeAway.tween_property(player, "modulate:a", 0.0, 1.0)
	await fadeAway.finished
	
	change_texture(closeTexture)
	place_player(player)
	
	await leadsTo.exit_door(player)

func exit_door(player: Player) -> void:
	change_texture(openTexture)
	
	player.actionState = States.ActionState.DOOR_EXIT
	
	player.modulate.a = 0.0
	var fadeIn = create_tween()
	fadeIn.tween_property(player, "modulate:a", 1.0, 1.0)
	await fadeIn.finished
	
	change_texture(closeTexture)
	player.can_move(true)
	
	player.actionState = States.ActionState.NONE
