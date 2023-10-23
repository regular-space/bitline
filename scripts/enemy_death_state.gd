class_name EnemyDeathState
extends State

@export var actor: EnemyChaser
@export var animator: AnimatedSprite2D
@export var collision: CollisionShape2D
@export var short_range: Area2D
@export var vision_cast: RayCast2D

var shooter

func _ready():
	set_physics_process(false)

func _enter_state():
	set_process(false)
	
	# For demo:
	Main.enemy_count -= 1
	HUD.update_counter(Main.enemy_count)
	
	animator.play("dead")
	collision.disabled = true
	short_range.monitoring = false
	
	vision_cast.enabled = false
	if vision_cast.rotation != 0:
		vision_cast.rotation = 0
	
	# Stop any timers from timing out after actor dies
	for n in actor.get_children():
		if n is Timer:
			if n.time_left > 0:
				n.stop()
	
	# Make sure other actors can walk over the corpse
	actor.z_index = 0
	
#func _physics_process(delta):
#	if test.is_colliding(): print("test!!!")

func _exit_state():
	set_physics_process(false)
