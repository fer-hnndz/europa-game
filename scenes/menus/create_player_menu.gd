extends Control

var accounts = {}

const LOGIN_INFO = "user://login_info.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_login_info()

func _on_create_player_button_down():
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

func _on_back_button_down():
	get_tree().change_scene_to_file("res://scenes/menus/login_menu.tscn")
