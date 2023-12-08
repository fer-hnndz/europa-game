extends Control

func _on_ready():
	var bus_name = "Music"
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, 0)

func _on_play_pressed():
	var bus_name = "Music"
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, -15)
	get_tree().change_scene_to_file("res://scenes/menus/Tutorial.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options_menu.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/login_menu.tscn")


func _on_highscore_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/HighScore.tscn")

