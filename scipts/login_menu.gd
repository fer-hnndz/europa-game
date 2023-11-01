extends Control

var accounts = {}

const LOGIN_INFO = "user://login_info.txt"

var isLogin = true

func _ready():
	load_login_info()

func _on_login_button_down():
	if isLogin:
		if $Username.text == "" or $Password.text == "":
			$btnPressedError.play()
			show_message("El nombre de usuario y la contraseña no pueden estar vacíos.")
		else:
			if $Username.text in accounts:
				if accounts[$Username.text] == $Password.text.sha256_text():
					get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
				else:
					$btnPressedError.play()
					show_message("Contrasena incorrecta")
			else:
				$btnPressedError.play()
				show_message("Usuario incorrecto o no existe")
	else:
		if $Username.text == "" or $Password.text == "":
			$btnPressedError.play()
			show_message("El nombre de usuario y la contraseña no pueden estar vacíos.")
		elif $Username.text in accounts:
			$btnPressedError.play()
			show_message("El nombre de usuario ya existe.")
		else:
			accounts[$Username.text] = $Password.text.sha256_text()
			set_login_info()
			$Username.text = ""
			$Password.text = ""
			$btnPressedError.play()
			show_message("Cuenta creada exitosamente, vuelve a login e ingresa tus credenciales para iniciar sesion")

func set_login_info():
	var file = FileAccess.open(LOGIN_INFO, FileAccess.WRITE)
	file.store_var(accounts)
 
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

func _on_change_menu_button_down():
	if isLogin:
		$LblGameName.text = "CREAR USUARIO"
		$LblGameName.position.x = 430
		isLogin = false
		$Login.text = "Crear Usuario"
		$ChangeMenu.text = "Volver a Login"
		$Login.position.x = 400
		$Username.text = ""
		$Password.text = ""
	else:
		$LblGameName.text = "LOGIN"
		$LblGameName.position.x = 562
		isLogin = true
		$Login.text = "Login"
		$ChangeMenu.text = "Crear Cuenta"
		$Login.position.x = 435
		$Login.size = Vector2(150,60)
		$Username.text = ""
		$Password.text = ""
	
	#get_tree().change_scene_to_file("res://scenes/menus/create_player_menu.tscn")
