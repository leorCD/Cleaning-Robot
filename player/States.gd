class_name States

enum MovementState{ # looping
	NONE,
	DEAD,
	STAND,
	CROUCH,
	REACH,
	WALK,
}

enum ActionState{ # one shot animations
	NONE,
	DIED,
	DOOR_ENTER,
	DOOR_EXIT,
}
