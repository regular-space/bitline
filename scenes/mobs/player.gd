class_name Player
extends CharacterBody2D

@export var speed = 75
@export var aim_distance = 50

func _ready():
	$AnimatedSprite2D.animation = "default"
	
func _process(delta):
	# Send player position to Main so other nodes can use it
	Main.player_position = self.position
	
	# Movement and input
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
		# Using self as origin point for bullet
		AI.shoot(self)
	
	if Input.is_action_pressed("aim"):
		# Using aim distance as radius; find a point in a circle around the player
		var final_x = aim_distance * cos(self.rotation)
		var final_y = aim_distance * sin(self.rotation)
		var cam_pos_tween = get_tree().create_tween()
#		var cam_zoom_tween = get_tree().create_tween()
		
		cam_pos_tween.tween_property($Camera2D, "offset", Vector2(final_x, final_y), 0.1)
#		cam_zoom_tween.tween_property($Camera2D, "zoom", Vector2(1.5, 1.5), 0.2)

	elif Input.is_action_just_released("aim"):
		var cam_pos_tween = get_tree().create_tween()
#		var cam_zoom_tween = get_tree().create_tween()
		
		cam_pos_tween.tween_property($Camera2D, "offset", Vector2.ZERO, 0.2)
#		cam_zoom_tween.tween_property($Camera2D, "zoom", Vector2(1.0, 1.0), 0.3)
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "moving"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.stop()	
		
	move_and_slide()
	self.look_at(get_global_mouse_position())

func hit(shooter):
	print(self.name + ": I'm hit!")
	Main.reload_scene()
