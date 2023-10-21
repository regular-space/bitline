class_name Player
extends CharacterBody2D

# var bullet = preload("res://scenes/mobs/bullet.tscn")

var speed = 75
var aim_distance = 60

func _ready():
	$AnimatedSprite2D.animation = "default"
	
func _process(delta):
	Main.player_position = self.position
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if Input.is_action_just_pressed("shoot"):
		AI.shoot(self)
	
	if Input.is_action_pressed("aim"):
		var radius = aim_distance
		var final_x = radius * cos(self.rotation)
		var final_y = radius * sin(self.rotation)
		var tween = get_tree().create_tween()
		tween.tween_property($Camera2D, "offset", Vector2(final_x, final_y), 0.2)
	elif Input.is_action_just_released("aim"):
		var tween = get_tree().create_tween()
		tween.tween_property($Camera2D, "offset", Vector2.ZERO, 0.3)
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "moving"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.stop()	
		
	move_and_slide()
	self.look_at(get_global_mouse_position())
	
#func shoot(shooter):
#	var new_bullet = bullet.instantiate()
#	var offset_length = 7
#	var final_x = offset_length * cos(self.rotation)
#	var final_y = offset_length * sin(self.rotation)
#	var offset = Vector2(final_x, final_y)
#	new_bullet.position = self.position + offset
#	new_bullet.direction = self.rotation
#	new_bullet.shooter = shooter
#	get_parent().add_child(new_bullet)

func hit(shooter_position):
	print("ouch!")
