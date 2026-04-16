class_name States

enum MovementState{ # looping
	NONE,
	STANDING,
	CROUCHING,
	REACHING,
}

enum ActionState{ # one shot animations
	NONE,
	DIED,
	DOOR_ENTER,
	DOOR_EXIT,
}
