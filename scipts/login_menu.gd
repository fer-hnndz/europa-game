extends Control

var username
var password
var created = false

const LOGIN_INFO = "user://login_info.txt"

func _ready():
	load_login_info()

func _on_login_button_down():
	if !created:
		if $Username.text == "" or $Password.text == "":
			show_message("El nombre de usuario y la contraseña no pueden estar vacíos.")
		else:
			username = $Username.text
			password = $Password.text.sha256_text()
			set_login_info(username, password)
			created = true
			$Login.text = "Login"
			$Username.text = ""
			$Password.text = ""
			show_message("Cuenta creada exitosamente, vuelve a ingresar tus credenciales para iniciar sesion")
	else:
		if $Username.text == "" or $Password.text == "":
			show_message("El nombre de usuario y la contraseña no pueden estar vacíos.")
		else:
			if $Username.text == username:
				if $Password.text.sha256_text() == password:
					get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
				else:
					show_message("Contrasena incorrecta")
			else: 
				show_message("Usuario incorrecto")

func set_login_info(user, psswrd):
	var file = FileAccess.open(LOGIN_INFO, FileAccess.WRITE)
	file.store_string(user + "\n" + psswrd)

func load_login_info() -> void:
	if FileAccess.file_exists(LOGIN_INFO):
		var file = FileAccess.open(LOGIN_INFO, FileAccess.READ)
		var lines = file.get_as_text().split("\n")
		if lines.size() >= 2:
			username = lines[0]
			password = lines[1]
			created = true
			$Login.text = "Login"

func show_message(msg):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()

func _on_quit_pressed():
	get_tree().quit()
