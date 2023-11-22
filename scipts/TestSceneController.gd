extends Node2D
var stages = {
	"0": {
		"enemies": [preload("res://scenes/characters/Bat.tscn")
		]
	},
	"1": {
		"enemies": [preload("res://scenes/characters/Bat.tscn"), 
					preload("res://scenes/characters/Bat.tscn"), 
					preload("res://scenes/characters/Bat.tscn")
		]
	},
	"2": {
		"enemies": [preload("res://scenes/characters/Astronaut.tscn"), 
					preload("res://scenes/characters/Bat.tscn"), 
					preload("res://scenes/characters/Bat.tscn"), 
					preload("res://scenes/characters/StoneGolem.tscn"), 
					preload("res://scenes/characters/StoneGolem.tscn"), 
					preload("res://scenes/characters/StoneGolem.tscn"), 
					preload("res://scenes/characters/StoneGolem.tscn"), 
					preload("res://scenes/characters/StoneGolem.tscn"), 
					
		]
	}
}
var current_stage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _get_enemies_alive() -> int:
	var enemies = 0
	for node in get_children():
		if node.get_class() == "CharacterBody2D" and node.name != "Player":
			enemies+=1
			
	return enemies

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (_get_enemies_alive() == 0):
		# Iniciar una nueva stage
		
		current_stage += 1
		if (current_stage > int(stages.keys()[-1])):
			print("has ganado")
			return
			
		var stage_data = stages[str(current_stage)]
		
		for enemy in stage_data["enemies"]:
			var r = RandomNumberGenerator.new()
			var player_pos = $Player.global_position

			var xd = r.randi_range(450, 750)
			var yd = r.randi_range(300, 550)
			var mod = 0
			
			while (mod == 0):
				mod = r.randi_range(-1, 1)		
	
			var rx = player_pos.x + (xd * mod)
			var ry = player_pos.y + (yd * mod)
			var enemy_instance = enemy.instantiate()
			enemy_instance.global_position = Vector2(rx, ry)
			add_child(enemy_instance)
