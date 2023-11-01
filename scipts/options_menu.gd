extends Control

@onready var music:AudioStreamPlayer = $"/root/MenuMusic"
@onready var musicChild = music.get_child(0)
@onready var musicChild2 = music.get_child(1)

#BUSCAR COMO MANDAR ESTA INFO A OTRAS ESCENAS
var music_pos = 0.0
var musicChild_pos = 0.0
var musicChild2_pos = 0.0

func _ready():
	if music.playing:
		$MuteResumebtn.text = "Sonido: encendido"
	elif musicChild.playing:
		"Mute Music"
	elif musicChild2.playing:
		"Mute Music"
	else:
		$MuteResumebtn.text = "Sonido: apagado"

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")

func _on_mute_resume_button_down():
	if music.playing:
		music_pos = music.get_playback_position()
		$MuteResumebtn.text = "Sonido: apagado"
		music.stop()
	elif musicChild.playing:
		musicChild_pos = musicChild.get_playback_position()
		$MuteResumebtn.text = "Sonido: apagado"
		musicChild.stop()
	elif musicChild2.playing:
		musicChild2_pos = musicChild2.get_playback_position()
		$MuteResumebtn.text = "Sonido: apagado"
		musicChild2.stop()
	else:
		$MuteResumebtn.text = "Sonido: encendido"
		if music_pos > 0.0:
			music.play(music_pos)
		elif musicChild_pos > 0.0:
			musicChild.play(musicChild_pos)
		elif musicChild2_pos > 0.0:
			musicChild2.play(musicChild2_pos)
