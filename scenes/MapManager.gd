extends Node2D

#var level_duration = 1 * 60 + 15 # 1:15 
var level_duration = 10
var level_end = 0
var currentMap = -1

var maps = [
	preload("res://scenes/Map1.tscn"),
	preload("res://scenes/Map2.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_unix_time_from_system() < level_end:
		return

	print("Changing map")
	level_end = Time.get_unix_time_from_system() + level_duration
	
	var new_map = currentMap
	while (new_map == currentMap):
		new_map = randi_range(0, maps.size() - 1)
	
	# Borrar el mapa actual
	remove_child(get_child(0))
	currentMap = new_map
	
	var loadedMap = maps[new_map].instantiate()
	add_child(loadedMap)
