extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -650.0
var has_double_jump = true
var last_bullet = 0
var bullet_cooldown = 0.055
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print($Line2D.get_point_count())
	
func _physics_process(delta):
	Engine.max_fps = 30
	#print(Engine.get_frames_per_second())
	var player_pos = position
	var mouse_pos = get_viewport().get_mouse_position() - player_pos
	
	#print("Distancia: ", player_pos.distance_to(mouse_pos))
	
	if ($Line2D.get_point_count() != 1):
		$Line2D.remove_point(1)		
	
	$Line2D.add_point(mouse_pos)
	
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
			bullet_instance.setObjective(mouse_pos)
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
