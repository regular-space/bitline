class_name Enemy
extends Mob

# Detection range
@export var wander_speed : float
@export var cast_width : float
@export var cast_unit : float
@export var cast_length : float
@export var cast_rotation_direction : bool 	# If false, subtract
@export var chase_speed : float
@export var vision_cast : RayCast2D

@export var finite_state_machine : FiniteStateMachine

func _physics_process(delta):
	if finite_state_machine.state.name != "EnemyDeathState":
	
		# Rotate the vision_cast to make a large detection area
		if cast_rotation_direction == false:
			if vision_cast.rotation == -cast_width:
				cast_rotation_direction = true
			else:
				vision_cast.rotation -= cast_unit
				if vision_cast.rotation < -cast_width:
					vision_cast.rotation = -cast_width
		elif cast_rotation_direction == true:
			if vision_cast.rotation == cast_width:
				cast_rotation_direction = false
			else:
				vision_cast.rotation += cast_unit
				if vision_cast.rotation > cast_width:
					vision_cast.rotation = cast_width
