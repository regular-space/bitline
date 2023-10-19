extends CharacterBody2D

var states = ["idle", "wander", "chase", "shoot", "dead"]
var state_index
var sees_player = false
var detect_player = false
var shoot_timer_started = false
var chase_timer_started = false

func _ready():
#	sees_player = true
#	$ShootTimer.start()
	pass

func _physics_process(delta):
	# Player walked into Detection Area; Shooter checks for line of sight
	if $LineOfSight.enabled:
		$LineOfSight.look_at(Main.player_position)
		if $LineOfSight.is_colliding():
			if $LineOfSight.get_collider().name == "Player":
				print(self.name + " sees player")
				sees_player = true
				$LineOfSight.enabled = false
				
				if chase_timer_started == true:
					$ChaseTimer.stop()
					chase_timer_started = false
					print(self.name + ": stopped chase timer")
	
	# Player is in detection area and shooter has line of sight. Player needs to leave detection area to stop shooting.
	if sees_player == true:
		self.look_at(Main.player_position)
		if shoot_timer_started == false:
			$ShootTimer.start()
			shoot_timer_started = true
		
func hit(attacker):
	AI.death_state(attacker, self)

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		print("Player is in " + self.name + "'s peripheral vision.")
		$LineOfSight.enabled = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		sees_player = false
		shoot_timer_started = false
		$ShootTimer.stop()
		print(self.name + " lost the player and will begin the chase!")
		
		$ChaseTimer.start()
		chase_timer_started = true
		
		### Start chasing the player
		
func _on_chase_timer_timeout():
	print(self.name + " gave up chasing Player.")
	
	### Set the enemy to wander

func _on_shoot_timer_timeout():
	if sees_player == true:
		AI.shoot(self)
		print(self.name + " takes the shot!")
		$ShootTimer.start()
	else:
		shoot_timer_started = false
		$ShootTimer.stop()
