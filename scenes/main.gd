extends Node2D
@onready var title_splash = $TitleSplash

# Demo
@onready var demo_level = preload("res://scenes/demo/proof_of_concept_level.tscn")

#var bouncy_bullets = true
var player_position = Vector2()

# For demo:
var enemy_count : int
var enemy_count_total : int

func _ready():
	title_splash.show()
	print("Main: ready.")

func _physics_process(delta):
	if title_splash.visible:
		title_input_check()
			
func title_input_check():
	if title_splash.visible == true:
		get_tree().paused = true
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("reload"):
		get_tree().paused = false
		title_splash.hide()
		
		# For demo
		enemy_count = enemy_count_total
		HUD.rich_text_label.text = "enemies: " + str(Main.enemy_count) + " / " + str(Main.enemy_count_total)

# Quick and dirty scene changer
func reload_scene():
	var old_scene
	var new_scene = demo_level.instantiate()
	new_scene.set_process(false)
	enemy_count_total = 0
	for n in get_tree().get_nodes_in_group("level"):
		if n == null:
			print("No levels to delete... oooops.")
		else:
			n.queue_free()
	get_node("/root/").add_child(new_scene)
#	enemy_count_total = 0
	new_scene.set_process(true)
	enemy_count = enemy_count_total
	HUD.update_counter(enemy_count)
	
	
