extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process_healthbar():
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_child(0)
	$HealthBar.max_value = player.MAX_HEALTH
	player.current_health -= 0.09
	$HealthBar.value = player.current_health
	$HealthLabel.text = str(player.current_health) + "/" + str(player.MAX_HEALTH)
	print(player.current_health)
