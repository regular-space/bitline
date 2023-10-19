extends CharacterBody2D

var direction
var speed = 500
var shooter

func _ready():
	pass
	
func _process(delta):
	velocity = Vector2(speed, 0).rotated(direction)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(shooter)
			self.queue_free()
		else:
			self.queue_free()

func _on_timer_timeout():
	self.queue_free()
