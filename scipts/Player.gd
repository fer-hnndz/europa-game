extends CharacterBody2D


var SPEED = 0
const JUMP_VELOCITY = -650.0
var has_double_jump = true
var last_bullet = 0

var bullet_cooldown = 0.1
var knockack_modifier = 750;
var LASER_MAX_LENGTH = 250
var current_health = 35
var MAX_HEALTH = 35
var spawned = true
var last_colission
var punished = false
var isStunned = false
var death_screen_visible = false
const NORMAL_SPEED = 15000
const DASH_SPEED = NORMAL_SPEED * 4
var invencibility_end = 0

var dash_cooldown = 5
var dash_available = 0
var dash_end = 0
var current_animation
var current_frame

var last_blink_change = 0

var heavy_fire_available = 0
@onready var dash_timer = Timer.new()

# La velocidad minima que tiene que tener para que el jugador sea penalizado
var punish_bias = 200
var punish_end = 0.09

var lastReceivedAttack = 0
var player_ui_controller
var heavy_bullet_ready
var heavy_bullet_reloading
var dash_ready
var dash_reloading
var has_despawned = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var stageControllerScript = preload("res://scipts/StageController.gd")

func _ready():
	dash_timer.one_shot = true
	
	stageControllerScript.new()
	spawned = false
	$AnimatedSprite2D.animation = "spawn"
	$AnimatedSprite2D.play()
	
	
	player_ui_controller = get_parent().get_node("PlayerUI")
	heavy_bullet_ready = player_ui_controller.get_node("HeavyBulletReady")
	heavy_bullet_reloading = player_ui_controller.get_node("HeavyBulletReloading")
	dash_ready = player_ui_controller.get_node("DashReady")
	dash_reloading = player_ui_controller.get_node("DashReloading")

func _despawn():
	spawned = false
	$AnimatedSprite2D.animation = "spawn"
	$AnimatedSprite2D.frame = 4
	$AnimatedSprite2D.play_backwards()
	has_despawned = true
	
func spawn_new_gun_sound():
	var audio_player = AudioStreamPlayer2D.new()
	
	audio_player.set_bus(&"Sfx")
	audio_player.stream = preload("res://Sounds/fire-trimmed.wav")
	audio_player.pitch_scale = 2
	add_child(audio_player)
	audio_player.play()
	
func spawn_new_heavy_gun_sound():
	var audio_player = AudioStreamPlayer2D.new()
	
	audio_player.stream = preload("res://Sounds/fire-trimmed.wav")
	add_child(audio_player)
	audio_player.play()

func spawn_new_dash_sound():
	var audio_player = AudioStreamPlayer2D.new()
	
	audio_player.stream = preload("res://Sounds/dash.ogg")
	add_child(audio_player)
	audio_player.play()
	
func spawn_new_damage_sound():
	var audio_player = AudioStreamPlayer2D.new()
	
	audio_player.stream = preload("res://Sounds/damage.ogg")
	add_child(audio_player)
	audio_player.play()
	
func process_unused_streams():
	for c in get_children():
		if (c.get_class() == "AudioStreamPlayer2D"):
			if (not c.playing):
				c.queue_free()
			
func _physics_process(delta):	
	process_unused_streams()
	current_animation = $AnimatedSprite2D.animation
	current_frame = $AnimatedSprite2D.frame
	
	
	# Detectar si la animacion de spawn ha terminado
	if ($AnimatedSprite2D.frame == 5 and spawned == false and $AnimatedSprite2D.animation == "spawn"):
		spawned = true
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
		print("[Player physics] Ya se puede mover")
	
	# Si la animacion de muerte termino, mostrar pantalla de muerte
	if ($AnimatedSprite2D.animation == "death" and $AnimatedSprite2D.frame ==  4) and not death_screen_visible:
		#get_parent().get_node("PlayerUI").queue_free()
		var death_screen = load("res://scenes/menus/DeathScreen.tscn").instantiate()
		get_parent().add_child(death_screen)
		death_screen_visible = true
		
		
#	if ($AnimatedSprite2D.animation == "spawn" and $AnimatedSprite2D.frame == 0 and not has_despawned):
#		print("DESPAWNEDDD")
#		has_despawned = true
		
	if (spawned == false):
		return
	
	# Handling de invencibilidad
	if (invencibility_end > Time.get_unix_time_from_system()):
		
		if (last_blink_change + 0.1 < Time.get_unix_time_from_system()):
			if ($AnimatedSprite2D.modulate.a == 1.0):
				$AnimatedSprite2D.modulate = Color(Color.WHITE, 0.2)
			else:
				$AnimatedSprite2D.modulate = Color.WHITE
			
			last_blink_change = Time.get_unix_time_from_system()
		
		#$AnimatedSprite2D.modulate.a = 0.5 if Engine.get_frames_drawn() % 2 == 0 else 1.0
#		if (Engine.get_frames_drawn() % 2 == 0):
#			$AnimatedSprite2D.modulate = Color.WHITE
#		else:
#			$AnimatedSprite2D.modulate = Color(Color.WHITE, 0.6)
		#$AnimatedSprite2D.modulate = Color(Color.WHITE, 0.7)
	else:
		$AnimatedSprite2D.modulate = Color.WHITE
		
	if (current_health <= 0):
		print("Tu ta muelto broder")
		player_ui_controller.set_highscore_info(player_ui_controller.score)
		$AnimatedSprite2D.animation = "death"
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play()
		spawned = false
		return
			
	
	_process_laser(delta)
	
	# Actualizar si deberia de estar punished
	if ( (velocity.x > 0 and velocity.x < punish_end) or (velocity.x < 0 and velocity.x > -punish_end) and punished):
		punished = false
		$AnimatedSprite2D.animation = "running"
		
	process_movement(delta)
	process_playerFire(delta)
	
	#if Input.is_key_pressed(KEY_L):
		

func deal_damage(damage: int, origin: Vector2):
	
	if (invencibility_end > Time.get_unix_time_from_system()):
		return
	
	spawn_new_damage_sound()
	current_health -= damage;
	
	if current_health < 0:
		current_health = 0
	
	var knockback_direction = origin.direction_to(global_position)
	var strength
	
	if (damage == 2):
		print("knock bat")
		strength = 1000
	else:
		strength = (damage * damage * damage * damage * damage)
	var knockback = knockback_direction * strength
	
	velocity = knockback
	move_and_slide()
	print("[Player.gd - deal_damag] aplicado")
	invencibility_end = Time.get_unix_time_from_system() + 2.5
	#$AnimatedSprite2D.modulate = Color(Color.WHITE, 0.6)
#
#=================
# Funciones de Laser
#=================
func _process_laser(delta):
	var laser_end = _get_laser_endpoint()
		
	if ($Line2D.get_point_count() != 1):
		$Line2D.remove_point(1)
	
	#$Line2D.add_point(mouse_pos)
	$Line2D.add_point(laser_end)
	
func _get_laser_endpoint() -> Vector2:
	var player_pos = global_position
	var mouse_pos = get_global_mouse_position() - player_pos
	
	var line_length = sqrt((mouse_pos.x * mouse_pos.x) + (mouse_pos.y * mouse_pos.y))	
	var laser_x = (LASER_MAX_LENGTH * mouse_pos.x) / line_length
	var laser_y = (LASER_MAX_LENGTH * mouse_pos.y) / line_length
	return Vector2(laser_x, laser_y)
		
func process_movement(delta):
	var destination = Vector2(0, 0)
	
	var keepDashing = Time.get_unix_time_from_system() < dash_end
	var canDash = Time.get_unix_time_from_system() >= dash_available
	
	if canDash:
		dash_ready.visible = true
		dash_reloading.visible = false
	
	if Input.is_action_just_pressed("dash") and not keepDashing and canDash:
		spawn_new_dash_sound()
		print("pressed dash")
		dash_end = Time.get_unix_time_from_system() + 0.3
		dash_available = Time.get_unix_time_from_system() + 5
		
		dash_ready.visible = false
		dash_reloading.visible = true
	
	SPEED = DASH_SPEED if keepDashing else NORMAL_SPEED
	
	
	
	# Add the gravity.
	if not is_on_floor():
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.set_frame(0)
		destination.y += velocity.y + gravity * delta
	else:
		$AnimatedSprite2D.play()
		has_double_jump = true
			
	isStunned = Time.get_unix_time_from_system() - lastReceivedAttack <= 0.09
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") && has_double_jump && !isStunned:
		destination.y = JUMP_VELOCITY;
		if not is_on_floor():
			has_double_jump = false
		

	#============================
	# MOVIMIENTO LATERAL
	#============================
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		
		
	if (punished and not is_on_floor()):
		velocity.x = 0;
		punished = false
		
	
	if direction && !isStunned:
		
		# No ha terminado de acelerar completamente, aplicar punish anim.
		
		var shouldPunish = (direction == -1 and velocity.x > punish_bias) or (direction == 1 and velocity.x < -punish_bias)
		if ( (shouldPunish or punished) and is_on_floor()):
			if ($AnimatedSprite2D.animation != "brake"):
				$AnimatedSprite2D.animation = "brake"
				$AnimatedSprite2D.frame = 0;
				
				print("[Player.gd] Player is now punished")
				punished = true
				$AnimatedSprite2D.play();
				$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
				
			# Desacelerar mas rapido por el "frenado"	
			velocity.x = lerp(velocity.x, 0.0, 0.35)
		else:
			destination.x = direction * SPEED * delta;
	elif direction == 0:
		# Si no hay direccion, desacelerar.
		# Desacelerar mas rapido si esta en punished.
		
		if (punished):
			velocity.x = lerp(velocity.x, 0.0, 0.35)
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.15)
			
	velocity.y = destination.y
	velocity.x = lerp(velocity.x, destination.x, 0.1)
	# Antes de mover, animar
	process_anims(direction)
	
	move_and_slide()
			
func process_anims(direction: int):
	# Animations
	if direction > 0 and not punished:
		get_node("AnimatedSprite2D").animation = "running"
		
		if (not Input.is_action_pressed("shoot")):
			get_node("AnimatedSprite2D").flip_h = false
			
		get_node("AnimatedSprite2D").play()
		
	elif direction < 0 and not punished:
		get_node("AnimatedSprite2D").animation = "running"
		
		if (not Input.is_action_pressed("shoot")):
			get_node("AnimatedSprite2D").flip_h = true
		
	elif direction == 0 and not punished:
		#print("idle")
		get_node("AnimatedSprite2D").animation = "idle"
		
func process_playerFire(delta):
	if Input.is_action_pressed("shoot") and !isStunned and not punished:	
		if (last_bullet == 0 or Time.get_unix_time_from_system() - last_bullet>= bullet_cooldown):
			
			# Guardar tiempo donde se disparo la ultima bala para comprobar si despues puede disparar otra
			last_bullet = Time.get_unix_time_from_system()
			
			# Cargar la bala y ubicarla para disparar
			var bullet_instance = preload("res://scenes/characters/Bullet.tscn").instantiate()
			var player_pos = global_position
			bullet_instance.global_position = Vector2(player_pos.x + 10, player_pos.y)
			
			spawn_new_gun_sound()
			
			get_parent().add_child(bullet_instance)
			bullet_instance.setObjective(player_pos.direction_to(_get_laser_endpoint()) + _get_laser_endpoint())

			# Rotar jugador en base la direccion que dispara
			if (bullet_instance.objective.x < 0):
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			
			
				
	var canHeavyFire = Time.get_unix_time_from_system() >= heavy_fire_available
	
	if canHeavyFire:
		heavy_bullet_ready.visible = true
		heavy_bullet_reloading.visible = false
	
	if Input.is_action_just_pressed("heavy_fire") and canHeavyFire:
		heavy_fire_available = Time.get_unix_time_from_system() + 12
		
		# Cargar la bala y ubicarla para disparar
		var bullet_instance = preload("res://scenes/characters/HeavyBullet.tscn").instantiate()
		var player_pos = global_position
		bullet_instance.global_position = Vector2(player_pos.x + 5, player_pos.y - 20)
		
		spawn_new_heavy_gun_sound()
		get_parent().add_child(bullet_instance)
		bullet_instance.setObjective(player_pos.direction_to(_get_laser_endpoint()) + _get_laser_endpoint())

		# Rotar jugador en base la direccion que dispara
		if (bullet_instance.objective.x < 0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			
		heavy_bullet_ready.visible = false
		heavy_bullet_reloading.visible = true
		

# Funcion ejecutada cuando un cuerpo entra en contacto con el jugador
func _on_hitbox_area_entered(area):
	#print(area.get_parent().name)
	deal_damage(area.get_parent().damage_caused, area.get_parent().global_position)
