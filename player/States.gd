class_name States

enum MovementState{ # looping
	NONE,
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
