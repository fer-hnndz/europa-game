extends Node

var player_ui
var min_enemies = 4
var enemies
var last_enemy_spawn = 0
var last_y_pos = 0
var spawned_initial_enemies = false
# Called when the node enters the scene tree for the first time.

var bat = preload("res://scenes/characters/Bat.tscn")
var stoneGolem = preload("res://scenes/characters/StoneGolem.tscn")
var astronaut = preload("res://scenes/characters/Astronaut.tscn")

var currentEnemies = 0

func _ready():
	player_ui = get_parent().get_child(1)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Verificar cantidad de enemigos	
	
	if not spawned_initial_enemies:
		spawned_initial_enemies = true
		spawn_initial_enemies()
		
	# Actualizar la cantidad de enemigos actuales
	
	currentEnemies = 0
	for el in get_parent().get_children():
		if (el.get_class() == "CharacterBody2D"):
			if not (el.get_name() == "Player"):
				currentEnemies+=1
	
	if currentEnemies == 0:
		print("Generando nuevos enemigos en base a score: " + str(player_ui.score))
		spawn_enemies(player_ui.score)
	
func spawn_initial_enemies():
	for i in range(4):
		var b = bat.instantiate()
		var starting_pos = generate_rand_pos()
		
		b.global_position = starting_pos
		print("Enemigo generado en pos: " + str(starting_pos))
		currentEnemies += 1
		
		get_parent().add_child(b)
	print("Generados")
	
	

func spawn_enemies(score: int):
	
	var enemy_scenes = [
		preload("res://scenes/characters/StoneGolem.tscn"),
		preload("res://scenes/characters/Astronaut.tscn"),
		preload("res://scenes/characters/Bat.tscn")
	]

	# Golems
	while (score > 0):
		var new_enemy = enemy_scenes[randi() % enemy_scenes.size()].instantiate()
		new_enemy.global_position = generate_rand_pos()
		
		if (score - new_enemy.xp_cost >= 0):
			currentEnemies += 1
			get_parent().add_child(new_enemy)	
			score -= new_enemy.xp_cost
		else:
			break
		
	
	# Astronautas
	while (true):
		var new_enemy = astronaut.instantiate()
		new_enemy.global_position = generate_rand_pos()
		
		if (score - new_enemy.xp_cost < 0):
			break;
		else:
			currentEnemies += 1
			get_parent().add_child(new_enemy)	
			score -= new_enemy.xp_cost
	
	#Bat				
	while (true):
		var new_enemy = bat.instantiate()
		new_enemy.global_position = generate_rand_pos()
		
		if (score - new_enemy.xp_cost < 0):
			break;
		else:
			currentEnemies += 1
			get_parent().add_child(new_enemy)	
			score -= new_enemy.xp_cost	
		
func generate_rand_pos() -> Vector2:
	var possible_x_pos = [-190, 1480]
	
	var y_pos = last_y_pos
	while(abs(y_pos - last_y_pos) <= 85):
		y_pos = randi_range(0, 700)
		
	var x_pos = possible_x_pos[randi() % possible_x_pos.size()]
	
	return Vector2(x_pos, y_pos)
