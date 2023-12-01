extends Node2D

#var level_duration = 1 * 60 + 15 # 1:15 
var level_duration = 15
var level_end = 0
var currentMap = -1

var maps = [
	preload("res://scenes/Map1.tscn"),
	preload("res://scenes/Map2.tscn"),
	preload("res://scenes/Map3.tscn"),
	preload("res://scenes/Map4.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# No procesar nada si no se ha terminado el tiempo del nivel
	if Time.get_unix_time_from_system() < level_end:
		return
	
	var player = null
	if (get_child_count() > 0):		
		player = get_child(0).get_child(0)
		
	if (player != null):
		print("Saving player info")
		#var last_player_health = get_child().get_child(0).current_health
		#var last_exp = 	
		
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
	# Borrar el mapa actual
	remove_child(get_child(0))
	currentMap = new_map
	
	var loadedMap = maps[new_map].instantiate()
	add_child(loadedMap)
	
	
