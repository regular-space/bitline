extends CanvasLayer
@onready var rich_text_label = $RichTextLabel

func _ready():
	print("HUD: ready.")
	
func update_counter(new_enemy_count):
	rich_text_label.text = "enemies: " + str(Main.enemy_count) + " / " + str(Main.enemy_count_total)
	print("HUD updated.")
