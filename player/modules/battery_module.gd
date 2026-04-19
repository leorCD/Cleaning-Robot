extends Node2D
class_name BatteryModule

@onready var player : Player = self.get_parent()
@export var batteryFill : Panel = null

var currBattery : float = 100
var maxBattery : int = 100 # just 100 %
var batteryDepletionRate : float = 2.0 # per second

var maxFillSizeX : float = 0
func _ready() -> void:
	if not batteryFill: return
	maxFillSizeX = batteryFill.size.x


func _process(delta: float) -> void:
	if not batteryFill: return
	
	if player.direction and not player.freezeMovement:
		subtract_battery(batteryDepletionRate * delta)
	
	if currBattery <= 0:
		batteryFill.size.x = 0
	else:
		var newRectSizeX = (currBattery / maxBattery)
		batteryFill.size.x = maxFillSizeX * newRectSizeX
	
	if currBattery >= 50:
		batteryFill.modulate = Color(0.636, 0.926, 0.383, 1.0)
	elif currBattery >= 20:
		batteryFill.modulate = Color(0.924, 0.542, 0.194, 1.0)
	elif currBattery >= 0:
		batteryFill.modulate = Color(0.737, 0.138, 0.188, 1.0)

func subtract_battery(depletionAmount) -> void:
	if not batteryFill: return
	if currBattery <= 0: return # pre check if already dead
	
	currBattery -= depletionAmount
	
	if currBattery <= 0: # only reached if they just died
		currBattery = 0
		player.die()
