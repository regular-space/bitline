extends Projectile

var direction
var speed = 400
var shooter

func _ready():
	pass
	
func _process(delta):
	velocity = Vector2(speed, 0).rotated(direction)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("can_die"):
			collision.get_collider().finite_state_machine.change_state(collision.get_collider().enemy_death_state)
			collision.get_collider().look_at(shooter.position)
			self.queue_free()
		else:
			self.queue_free()

func _on_timer_timeout():
	self.queue_free()
