class_name EnemyDeathState
extends State

@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var collision: CollisionShape2D

var shooter

func _ready():
	set_physics_process(false)

func _enter_state():
	set_physics_process(false)
	animator.play("dead")
	collision.disabled = true

func _exit_state():
	set_physics_process(false)
