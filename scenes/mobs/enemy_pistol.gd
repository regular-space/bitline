extends CharacterBody2D

var states = ["idling", "wandering", "chasing", "shooting"]

var has_seen_player = false

var is_chasing = false
var is_shooting = false

var shoot_timer_started = false
var chase_timer_started = false

func _ready():
	pass

func _physics_process(delta):

	# Assuming Player is in the area...
	if $LineOfSight.enabled:
		if is_chasing == false:
			$LineOfSight.look_at(Main.player_position)
		if $LineOfSight.is_colliding():
	
			# First sighting
			if $LineOfSight.get_collider().name == "Player" and has_seen_player == false:
				self.look_at(Main.player_position)
				if is_shooting == false:
					is_chasing = false
					print(self.name + " sees player for first time and starts shooting!")
					has_seen_player = true
					$LineOfSight.rotation = 0
					is_shooting = true
					$ChaseTimer.stop()
					$ShootTimer.start()
			
			elif $LineOfSight.get_collider().name == "Player" and has_seen_player == true: # and is_chasing == false:
				self.look_at(Main.player_position)
				if is_shooting == false:
					is_chasing = false
					print(self.name + " sees player and starts shooting!")
					$LineOfSight.rotation = 0
					is_shooting = true
					$ChaseTimer.stop()
					$ShootTimer.start()
			
			# If player manages to break line of sight after being seen
			elif $LineOfSight.get_collider().name != "Player" and has_seen_player:
				if is_chasing == false:
					$LineOfSight.rotation = 0
					is_shooting = false
					AI.chase()
					is_chasing = true
					$ChaseTimer.start()
					$ShootTimer.stop()
		
			else: # Player is in area but no direct line of sight; LOS starts search 
				pass
		
#		elif $LineOfSight.is_colliding() == false and is_shooting == true:
#			print("Player left sight and " + self.name + " wants to chase!")
#			if is_chasing == false:
#				$LineOfSight.rotation = 0
#				is_shooting = false
#				print(self.name + " wants to chase!")
#				is_chasing = true
#				$ChaseTimer.start()
#				$ShootTimer.stop()
		
func hit(attacker):
	AI.death_state(attacker, self)

func _on_detection_area_body_entered(body):
	if body.name == "Player": # and is_chasing == false: # and has_seen_player == false:
#		print("Player is in " + self.name + "'s peripheral vision.")
		$LineOfSight.enabled = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		if has_seen_player == true and is_chasing == false:
			$LineOfSight.enabled = false
			AI.chase()
			### Start chasing the player
		else:
			$LineOfSight.enabled = false
		
func _on_chase_timer_timeout():
	print(self.name + " gave up chasing Player.")
	is_chasing = false
	has_seen_player = false
	AI.wander()

func _on_shoot_timer_timeout():
#	if sees_player == true:
#		AI.shoot(self)
#		print(self.name + " takes the shot!")
#		$ShootTimer.start()
#	else:
#		shoot_timer_started = false
#		$ShootTimer.stop()
	pass
