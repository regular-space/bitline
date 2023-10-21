class_name EnemyChaseState
extends State

@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D
@export var chase_timer: Timer
@onready var finite_state_machine = $".."
@onready var enemy_death_state = $"../EnemyDeathState"

signal lost_player

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("moving")

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta) -> void:
	# Movement
	actor.look_at(Main.player_position)
	actor.velocity = actor.chase_speed * actor.position.direction_to(Main.player_position)
	actor.move_and_slide()
	
	if vision_cast.is_colliding() == false:
		if chase_timer.time_left == 0:
			print("Lost player")
		start_chase_timer()
	elif vision_cast.is_colliding():
		if vision_cast.get_collider() == null:
			pass
		elif vision_cast.get_collider().is_in_group("projectile"): pass
		elif vision_cast.get_collider().is_in_group("enemy"): pass
		elif vision_cast.get_collider().is_in_group("player"):
			if chase_timer.time_left > 0:
				chase_timer.stop()
				print("Timer stopped")
		else:
			print("This is probably a wall")
			start_chase_timer()

func start_chase_timer() -> void:
	if chase_timer.is_stopped() == true:
		chase_timer.start()
		print("Chase timer started")

func _on_timer_timeout():
	print("Chase end")
	if finite_state_machine.state != enemy_death_state:
		lost_player.emit()
