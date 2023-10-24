extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -650.0
var has_double_jump = true
var last_bullet = 0
var bullet_cooldown = 0.055
var LASER_MAX_LENGTH = 250

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print($Line2D.get_point_count())
	
func _physics_process(delta):
	#Engine.max_fps = 30
	#print(Engine.get_frames_per_second())
	var player_pos = global_position
	var mouse_pos = get_global_mouse_position() - player_pos
	
	#var laser_x = (LASER_MAX_LENGTH / mouse_pos.x) * mouse_pos.x
	#var laser_y = (LASER_MAX_LENGTH / mouse_pos.y) * mouse_pos.y
	#var laser_end = Vector2(laser_x, laser_y)
	
	var line_length = sqrt((mouse_pos.x * mouse_pos.x) + (mouse_pos.y * mouse_pos.y))	
	var laser_x = (LASER_MAX_LENGTH * mouse_pos.x) / line_length
	var laser_y = (LASER_MAX_LENGTH * mouse_pos.y) / line_length
	var laser_end = Vector2(laser_x, laser_y)
		
	print("C = ", line_length)
	
		
	if ($Line2D.get_point_count() != 1):
		$Line2D.remove_point(1)
	
	#$Line2D.add_point(mouse_pos)
	$Line2D.add_point(laser_end)

	
	# Add the gravity.
	if not is_on_floor():
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.set_frame(0)
		velocity.y += gravity * delta
	else:
		$AnimatedSprite2D.play()
		has_double_jump = true

	if Input.is_action_pressed("shoot"):	
		print(Time.get_unix_time_from_system() - last_bullet)
		if (last_bullet == 0 or Time.get_unix_time_from_system() - last_bullet>= bullet_cooldown):
			last_bullet = Time.get_unix_time_from_system()
			var bulletNode = preload("res://scenes/Bullet.tscn")
			var bullet_instance = bulletNode.instantiate()
			bullet_instance.setObjective(player_pos.direction_to(mouse_pos) + mouse_pos)
			var start_pos = global_position
			
			start_pos = Vector2(start_pos.x + 10, start_pos.y)
			bullet_instance.global_position = start_pos
			get_parent().add_child(bullet_instance)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") && has_double_jump:
		velocity.y = JUMP_VELOCITY ;
		if not is_on_floor():
			has_double_jump = false
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		
	if direction:
		velocity.x = direction * SPEED;
		#print(velocity.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Animations
	
	
	if velocity.x > 0:
		get_node("AnimatedSprite2D").animation = "running"
		get_node("AnimatedSprite2D").flip_h = false
		get_node("AnimatedSprite2D").play()
		
	elif velocity.x < 0:
		get_node("AnimatedSprite2D").animation = "running"
		get_node("AnimatedSprite2D").flip_h = true
		
	elif velocity.x == 0:
		#print("idle")
		get_node("AnimatedSprite2D").animation = "idle"
	move_and_slide()
