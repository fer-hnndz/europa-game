extends Node2D

#var level_duration = 1 * 60 + 15 # 1:15 
var level_duration = 5
var level_end = 0
var currentMap = -1
var last_player_health
var last_exp
var map_changes = 0

@onready var music:AudioStreamPlayer = $"/root/MenuMusic"

var maps = [
	preload("res://scenes/Map1.tscn"),
	preload("res://scenes/Map2.tscn"),
	preload("res://scenes/Map3.tscn"),
	preload("res://scenes/Map4.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	music.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# No procesar nada si no se ha terminado el tiempo del nivel
	if Time.get_unix_time_from_system() < level_end:
		return
	
	var player = null
	if (get_child_count() > 0):		
		player = get_child(0).get_child(0)
		
	if (player != null):
		if (not player.has_despawned):
			print("[MapManager] despawning...")
			player._despawn()
		
	# Esperar hasta que el jugador despawnee para cambiar de mapa
	if (player != null):
		if (not (player.has_despawned and player.current_animation == "spawn" and player.current_frame == 0)):
			return
		
	print("Changing map")
	var new_map = currentMap
	while (new_map == currentMap):
		new_map = randi_range(0, maps.size() - 1)
	
	level_end = Time.get_unix_time_from_system() + level_duration
	
	if (player != null):
		print("Saving player info")
		last_player_health = player.current_health
		var player_ui = get_child(0).get_child(1)
		last_exp = 	int(player_ui.score)
	
	print("Health: " + str(last_player_health) + " | Last XP: " + str(last_exp))
	
	# Borrar el mapa actual
	remove_child(get_child(0))
	currentMap = new_map
	
	var loadedMap = maps[new_map].instantiate()
	
	add_child(loadedMap)
	if (map_changes != 0):
		# Setear los valores de XP y HP
		var new_map_player = loadedMap.get_child(0)
		var new_map_ui = loadedMap.get_child(1)
		
		new_map_player.current_health = last_player_health
		new_map_ui.score = last_exp
	
	
	map_changes += 1
	
	
