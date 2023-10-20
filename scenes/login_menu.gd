extends Control

var username = ""
var password 

var created = false

func _on_login_button_down():
	if !created:
		username = $Username.text 
		password = $Password.text.sha256_text()
		created = true
		$Login.text = "Login"
		$Username.text = ""
		$Password.text = ""
		print("Account created")
	else:
		if $Username.text == username:
			if $Password.text.sha256_text() == password:
				print("Login Success!")
				get_tree().change_scene_to_file("res://menu.tscn")
			else: 
				print("Login fail!")
		else: 
				print("Login fail!")


func _on_quit_pressed():
	get_tree().quit()
