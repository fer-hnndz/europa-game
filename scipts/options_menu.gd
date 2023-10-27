extends Control

@onready var music:AudioStreamPlayer = $"/root/MenuMusic"

func _ready():
	if music.playing:
		$Option1.text = "Mute"
	else:
		$Option1.text = "Play music"

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")

func _on_option_1_button_down():
	if music.playing:
		$Option1.text = "Play music"
		music.stop()
	else:
		$Option1.text = "Mute"
		music.play()
