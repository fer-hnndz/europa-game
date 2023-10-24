extends Control

var username = ""
var password
var created = false

const LOGIN_INFO = "user://login_info.txt"

func _ready():
	load_login_info()

func _on_login_button_down():
	if !created:
		username = $Username.text 
		password = $Password.text.sha256_text()
		set_login_info(username, password)
		created = true
		$Login.text = "Login"
		$Username.text = ""
		$Password.text = ""
		print("Account created")
	else:
		if $Username.text == username:
			print("Correct username!")
			
			if $Password.text.sha256_text() == password:
				print("Correct password")
				get_tree().change_scene_to_file("res://menu.tscn")
			else:
				show_message("Login failed! Please check your password.")
		else: 
			show_message("Login failed! Please check your username.")
		
			
		
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
