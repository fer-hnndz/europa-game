extends CharacterBody2D
var spawned = true
var health = 82
var player
var SPEED = 1
var last_col
var damage_caused = 4
var ATTACK_STALL = 0.5
var last_attack = 0

var kill_xp = 7
var xp_cost = 8

var player_ui_controller


# Called when the node enters the scene tree for the first time.
func _ready():
#	$AnimatedSprite2D.animation = "spawn"
#	$AnimatedSprite2D.frame = 0
#	$AnimatedSprite2D.play()
	player = get_parent().get_node("Player")	
#
	player_ui_controller = get_parent().get_node("PlayerUI")
	
func add_damage(new_damage: float) -> void:
	if (not spawned):
		return
		
	health -= new_damage
	var t = Timer.new()
	
	t.set_one_shot(true)
	t.set_wait_time(0.5)
	
	# No volver a empepzar animacion de damage si ya esta en proceso
	if ($AnimatedSprite2D.animation == "damage"):
		return	
		
	$AnimatedSprite2D.animation = "damage"
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var finishedSpawnAnimation =$AnimatedSprite2D.frame == 7 and $AnimatedSprite2D.animation == "spawn"
	var finishedDamageAnimation = $AnimatedSprite2D.frame == 3 and $AnimatedSprite2D.animation == "damage"
#
#	if (finishedSpawnAnimation):
#		$AnimatedSprite2D.animation = "idle"
#		$AnimatedSprite2D.frame = 0
#		$AnimatedSprite2D.play()
#		spawned = true
#
#	if (not spawned):
#		return
#
	if (finishedDamageAnimation):
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play()
		
	if (health <= 0):
		player_ui_controller.increase_score(kill_xp)
		queue_free()
	
	if (player.current_health <= 0):
		return

	var player_pos = player.global_position
	var velocity = global_position.direction_to(player_pos)

	# No mover mientras no se haya completado el stall de
	if (Time.get_unix_time_from_system() <= self.last_attack + ATTACK_STALL):
		velocity = Vector2(0, 0)
	
	move_and_collide(velocity * SPEED)
	
