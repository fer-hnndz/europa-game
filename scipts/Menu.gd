extends Control



func _on_play_pressed():
	pass


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options_menu.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/login_menu.tscn")


func _on_highscore_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/HighScore.tscn")
