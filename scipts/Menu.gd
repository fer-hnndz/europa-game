extends Control

@onready var music:AudioStreamPlayer = $"/root/MenuMusic"

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/MapManager.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options_menu.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/login_menu.tscn")


func _on_highscore_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/HighScore.tscn")

func _on_ready():
	if (!music.playing):
		music.play()
