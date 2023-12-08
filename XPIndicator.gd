extends Node2D
var move = false
var spawn = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	move = true


func set_xp(xp: int):
	spawn = Time.get_unix_time_from_system()
	$Label.text = "+" + str(xp) + " XP"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (move):
		global_position.y -= 5
		
	if (Time.get_unix_time_from_system() > spawn + 0.5 and spawn != 0):
		queue_free()
