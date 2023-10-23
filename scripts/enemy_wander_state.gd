class_name EnemyWanderState
extends State

@export var actor: EnemyChaser
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D
@export var chase_timer: Timer
@export var wander_timer: Timer
@export var finite_state_machine: FiniteStateMachine
@export var enemy_death_state: EnemyDeathState
@export var short_detection_range: Area2D

var cast_unit = 0.1
var cast_rotation_direction = false # If false, subtract.

signal found_player

enum wander_state {PAUSE, MOVE, ROTATE}
var current_wander_state

func _ready():
	set_physics_process(false)
	wander_timer.timeout.connect(self._on_wander_timeout)
	short_detection_range.body_entered.connect(self._on_short_detect_player)
	
	if vision_cast.target_position.x != actor.cast_length:
		vision_cast.target_position.x = actor.cast_length

func _enter_state():
	set_physics_process(true)
	animator.play("default")
	chase_timer.stop()
	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.wander_speed
	current_wander_state = wander_state.find_key(randi() % wander_state.size())
	wander_timer.start()
	
	vision_cast.rotation = actor.cast_width
	cast_rotation_direction = false

func _on_wander_timeout():
	if finite_state_machine.state != enemy_death_state:
		current_wander_state = wander_state.find_key(randi() % wander_state.size())
		wander_timer.start()

func _exit_state() -> void:
	set_physics_process(false)
	if vision_cast.rotation != 0:
		vision_cast.rotation = 0
	wander_timer.stop()

func _physics_process(delta):
	actor.rotation = actor.velocity.angle()
	
	# Pause
	if current_wander_state == "PAUSE":
		if animator.animation != "default":
			animator.play("default")
	
	# Move
	elif current_wander_state == "MOVE":
		if animator.animation != "moving":
			animator.play("moving")
		
		var collision = actor.move_and_collide(actor.velocity * delta)
		if collision:
			var bounce_velocity = actor.velocity.bounce(collision.get_normal())
			actor.velocity = bounce_velocity
	
	# Rotate
	elif current_wander_state == "ROTATE":
		if animator.animation != "default":
			animator.play("default")
		
		var rotate_chance = randf_range(0, 1.0)
		if rotate_chance > 0.95:
			actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.wander_speed
	
	else:
		print(get_parent().name + ": Error! Out of wander states")
	
	# Find player
	if vision_cast.is_colliding():
		if vision_cast.get_collider() != null and vision_cast.get_collider().is_in_group("player"):
			found_player.emit()
	
func _on_short_detect_player(body):
	if body.is_in_group("player"):
		print(actor.name + ": Player is in my personal space!")
		found_player.emit()
