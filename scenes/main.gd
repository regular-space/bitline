extends Node2D

var bouncy_bullets = true
var player_position = Vector2()

func _ready():
	$TitleSplash.show()

func _physics_process(delta):
	title_input_check()
			
func title_input_check():
	if $TitleSplash.visible == true:
		get_tree().paused = true
	if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		$TitleSplash.hide()

