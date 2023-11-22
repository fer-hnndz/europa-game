extends Control

var return_available
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.color = Color (0, 0, 0, 1)
	return_available = Time.get_unix_time_from_system() + 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_unix_time_from_system() >= return_available:
		get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
