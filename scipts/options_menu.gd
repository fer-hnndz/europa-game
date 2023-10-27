extends Control

@onready var music:AudioStreamPlayer = $"/root/MenuMusic"

func _ready():
	music.stop()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
