extends Projectile

var direction
var shooter: CharacterBody2D
var speed = 500

func _ready():
	velocity = Vector2(speed, 0).rotated(direction)
	self.rotation = self.velocity.angle()
	
func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(direction)
	self.rotation = self.velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("can_die"):
			collision.get_collider().finite_state_machine.change_state(collision.get_collider().enemy_death_state)
			collision.get_collider().rotation = (self.rotation)
			self.queue_free()
		else:
			self.queue_free()

func _on_timer_timeout():
	self.queue_free()
