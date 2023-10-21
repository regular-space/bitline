class_name EnemyWanderState
extends State

@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D
@export var chase_timer: Timer

signal found_player

func _ready():
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)
	animator.play("moving")
	chase_timer.stop()
#	if actor.velocity == Vector2.ZERO:
	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.wander_speed

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	actor.rotation = actor.velocity.angle()
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
	#print("wander")
	
	if vision_cast.is_colliding():
		if vision_cast.get_collider() != null and vision_cast.get_collider().name == "Player":
			print("Found player")
			found_player.emit()
