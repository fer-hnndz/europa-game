extends Control

const HIGH_SCORE_PATH = "user://high_score.txt"
var highscore = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	load_highscore_info()
	$Lbl_puntos.text = str(highscore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_highscore_info() -> void:
	if FileAccess.file_exists(HIGH_SCORE_PATH):
		var file = FileAccess.open(HIGH_SCORE_PATH, FileAccess.READ)
		highscore = file.get_var()

#func set_highscore_info():
#	var file = FileAccess.open(HIGH_SCORE_PATH, FileAccess.WRITE)
#	file.store_var(highscore)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
