extends Control
var score = 0
const HIGH_SCORE_PATH = "user://high_score.txt"
var highscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process_healthbar():
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Actualizar xp text
	$Lbl_Points.text = str(score)
	
	
	print("Score: " + str(score))
	var player = get_parent().get_child(0)
	$HealthBar.max_value = player.MAX_HEALTH
	$HealthBar.value = player.current_health
	
	var map_manager = get_parent().get_parent()
	var level_end = map_manager.level_end
	var time_left = level_end - Time.get_unix_time_from_system()
	
	var minutes_left = floor(time_left/60)
	var seconds_left = time_left - (minutes_left * 60)
	
	if seconds_left < 10 and minutes_left > 0:
		seconds_left = str(seconds_left).pad_zeros(2).pad_decimals(2)
	else:
		seconds_left = str(seconds_left).pad_decimals(0)
	
	$TimeLabel.text = ""  + str(minutes_left) + ":" + seconds_left
	
	if (time_left < 0):
		$TimeLabel.text = "0:00";
	elif (seconds_left == "01.01" or seconds_left == "02.01" or seconds_left == "03.01" and minutes_left > 0):
		print("beep")
		var beep_sound = preload("res://beep.ogg")
	
		$AudioStreamPlayer.stream = beep_sound
		$AudioStreamPlayer.play()
	
	#$HealthLabel.text = str(player.current_health) + "/" + str(player.MAX_HEALTH)

func increase_score(points):
	score += points
	$Lbl_Points.text = str(score)
	
func set_highscore_info(new_score):
	var current_high_score = 0
	if FileAccess.file_exists(HIGH_SCORE_PATH):
		var file = FileAccess.open(HIGH_SCORE_PATH, FileAccess.READ)
		current_high_score = file.get_var()
	
	if new_score > current_high_score:
		var file = FileAccess.open(HIGH_SCORE_PATH, FileAccess.WRITE)
		file.store_var(new_score)
