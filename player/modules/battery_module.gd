extends Node2D
class_name BatteryModule

@onready var parent : Player = self.get_parent()
@export var batteryLabel : Label = null

var currBattery : float = 100
var maxBattery : int = 100 # just 100 %
var batteryDepletionRate : float = 2.0 # per second

func _physics_process(delta: float) -> void:
	if parent.direction and (not parent.velocity == Vector2.ZERO):
		subtract_battery(batteryDepletionRate * delta)
	
	if currBattery <= 0:
		batteryLabel.text = "you died"
	else:
		batteryLabel.text = str("%.2f" % currBattery) + " / " + str(maxBattery)

func subtract_battery(depletionAmount) -> void:
	if currBattery <= 0: return # pre check if already dead
	
	currBattery -= depletionAmount
	
	if currBattery <= 0: # only reached if they just died
		currBattery = 0
		parent.die()
