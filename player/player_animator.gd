extends AnimationPlayer

@onready var player : Player = self.get_parent()
var movementAnims = {
	States.MovementState.CROUCH : "crouch",
	States.MovementState.STAND : "idle",
	States.MovementState.REACH : "reach",
	States.MovementState.WALK : "walk",
}
var actionAnims = {
	States.ActionState.DIED : "died",
	States.ActionState.DOOR_ENTER : "door_enter",
	States.ActionState.DOOR_EXIT : "door_exit",
}

func _process(_delta: float) -> void:
	update_sprite()



func update_sprite() -> void:
	var actionAnim = actionAnims.get(player.actionState)
	if actionAnim: # blocks movement animations
		try_playing(actionAnim)
		return
	
	var movementAnim = movementAnims.get(player.movementState)
	if movementAnim: # if the current state is in the movement animation priority
		try_playing(movementAnim)

var attemptedAnimationName : String = ""
func try_playing(newAnimName : String) -> void:
	if attemptedAnimationName == newAnimName: # if you're trying to play the same anim and it didn't work last time
		return
	
	if not self.has_animation(newAnimName): # if animation doesnt exist
		push_warning("Nonexistent animation/sprite by the name : '" + newAnimName + "'")
		attemptedAnimationName = newAnimName
		return
	
	if self.current_animation != newAnimName:
		play(newAnimName)
