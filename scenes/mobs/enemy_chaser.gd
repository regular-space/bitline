class_name EnemyChaser
extends Enemy

#@export var chase_speed = 60.0
#@export var wander_speed = 40.0
#@export var cast_width = 1.0
#@export var cast_length = 60

# Ctrl click the states on the right and drag them here
# Then add "as (type)" for autocomplete
#@onready var finite_state_machine = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state = $FiniteStateMachine/EnemyChaseState as EnemyChaseState
@onready var enemy_death_state = $FiniteStateMachine/EnemyDeathState as EnemyDeathState

func _ready():
	print(self.name + ": ready.")
	# Connecting enemy_wander_state's found player signal to change_state function
	# Tells code to swap to enemy_chase_state
	enemy_wander_state.found_player.connect(finite_state_machine.change_state.bind(enemy_chase_state))
	enemy_chase_state.lost_player.connect(finite_state_machine.change_state.bind(enemy_wander_state))
	
	# For demo:
	Main.enemy_count_total += 1
	
