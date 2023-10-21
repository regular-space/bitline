extends Node

var bullet = preload("res://scenes/mobs/bullet.tscn")

func shoot_loop(shooter):
	pass

func shoot(shooter):
	var new_bullet = bullet.instantiate()
	var offset_length = 7
	var final_x = offset_length * cos(shooter.rotation)
	var final_y = offset_length * sin(shooter.rotation)
	var offset = Vector2(final_x, final_y)
	new_bullet.position = shooter.position + offset
	new_bullet.direction = shooter.rotation
	new_bullet.shooter = shooter
	get_parent().add_child(new_bullet)
	
func chase():
	print("Called AI.chase()")
	
func wander():
	print("Called AI.wander()")

func death_state(attacker, victim):
	if victim.name != "Player":
#		victim.set_process_mode(4)
		victim.look_at(attacker.position)
		if victim.has_node("AnimatedSprite2D"):
			victim.get_node("AnimatedSprite2D").animation = "dead"
		for n in victim.get_children():
			n.set_process_mode(4)
#			if n.name == "AnimatedSprite2D":
#				pass
#			else:	
#				victim.remove_child(n)
	else:
		print("AI.gd: Haven't handled player death yet...")
	
