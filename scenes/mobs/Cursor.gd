extends Sprite2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func _input(event):
	if event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("shoot") or event.is_action_pressed("aim"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func _process(delta):
	self.position = get_global_mouse_position()
