class_name EnemyChaseState
extends State

@export var finite_state_machine: FiniteStateMachine
@export var actor: EnemyChaser
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D
@export var chase_timer: Timer
@export var nav_timer: Timer
@export var enemy_death_state: EnemyDeathState

enum tracking_state {CHASING, BLOCKED}
var cur_tracking_state

var current_direction

signal lost_player

func _ready():
	set_physics_process(false)
	chase_timer.timeout.connect(self._on_chase_timer_timeout)
	nav_timer.timeout.connect(self._on_nav_timer_timeout)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("moving")
	cur_tracking_state = tracking_state.find_key(0)
	
	if vision_cast.enabled == false:
		vision_cast.enabled = true

func _exit_state() -> void:
	if vision_cast.rotation != 0:
		vision_cast.rotation = 0
	set_physics_process(false)
	
func _physics_process(delta) -> void:
	# Chase movement 
	var collision = actor.move_and_collide(actor.velocity * delta)
	
	if cur_tracking_state == "CHASING":
		actor.look_at(Main.player_position)
		actor.velocity = actor.chase_speed * actor.position.direction_to(Main.player_position)
	elif cur_tracking_state == "BLOCKED":	
		actor.move_and_collide(actor.velocity * delta)
#		print(actor.name + ": Pathing around...")
	
	check_vision_cast()
	check_collision(collision)
	
#	print(cur_tracking_state)

func check_collision(collision):
	# Check if actor has hit the player; trigger death state in player if so
	if collision:
		if collision.get_collider().is_in_group("player"):
#			print(actor.name + ": I'm touching the player!")
			collision.get_collider().hit(self)
		elif collision.get_collider().is_in_group("projectile"): pass
		elif collision.get_collider().is_in_group("enemy"): pass
		else:
			cur_tracking_state = tracking_state.find_key(1)
#			print(actor.name + ": I'm stuck on something")

	else: # If actor manages to get unstuck
		if vision_cast.rotation != 0:
			vision_cast.rotation = 0
		cur_tracking_state = tracking_state.find_key(0)

func check_vision_cast():
	# Check if the mob can see the player. If it can't, start chase timer.
	if vision_cast.is_colliding() == false:
		# Debug: 
#		if chase_timer.time_left == 0:
#			print("Lost player")
		start_chase_timer()
	elif vision_cast.is_colliding():
		if vision_cast.get_collider() == null: pass
		elif vision_cast.get_collider().is_in_group("projectile"): pass
		elif vision_cast.get_collider().is_in_group("enemy"): pass
		elif vision_cast.get_collider().is_in_group("player"):
			# Actor was chasing; found player again
			if chase_timer.time_left > 0:
				chase_timer.stop()
#				print("Timer stopped")

		# If actor is blocked by a wall, start chase timer and set tracking state to BLOCKED
		else:
#			print(actor.name + ": I see a wall.")
			start_chase_timer()

func _on_nav_timer_timeout() -> void:
#	make_path()
	pass
	
			
func start_chase_timer() -> void:
	if chase_timer.is_stopped() == true:
		chase_timer.start()
		print(actor.name + ": Chase timer started")

func _on_chase_timer_timeout() -> void:
#	print("Chase end")
	if finite_state_machine.state != enemy_death_state:
		lost_player.emit()
