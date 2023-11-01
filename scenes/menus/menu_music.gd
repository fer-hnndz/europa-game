extends AudioStreamPlayer

var num
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	num = randi_range(0,2)
	if (num == 0):
		$AudioStreamPlayer2.play()
		self.stop()
	elif (num == 1):
		$AudioStreamPlayer3.play()
		self.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_finished():
	$AudioStreamPlayer2.play()


func _on_audio_stream_player_2_finished():
	$AudioStreamPlayer3.play()


func _on_audio_stream_player_3_finished():
	self.play()
