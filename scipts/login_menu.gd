extends Control

var accounts = {}

const LOGIN_INFO = "user://login_info.txt"

func _ready():
	load_login_info()

func _on_login_button_down():
	if $Username.text == "" or $Password.text == "":
		show_message("El nombre de usuario y la contraseña no pueden estar vacíos.")
	else:
		if $Username.text in accounts:
			if accounts[$Username.text] == $Password.text.sha256_text():
				get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
			else:
				show_message("Contrasena incorrecta")
		else:
			show_message("Usuario incorrecto o no existe")

#func set_login_info(user, psswrd):
	#var file = FileAccess.open(LOGIN_INFO, FileAccess.WRITE)
	#file.store_var(accounts)

func load_login_info() -> void:
	if FileAccess.file_exists(LOGIN_INFO):
		var file = FileAccess.open(LOGIN_INFO, FileAccess.READ)
		accounts = file.get_var()

func show_message(msg):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()

func _on_quit_pressed():
	get_tree().quit()

func _on_create_button_down():
	get_tree().change_scene_to_file("res://scenes/menus/create_player_menu.tscn")
