extends CharacterBody2D
var spawned = false
var health = 82
var player
var SPEED = 2.2
var last_col
var damage = 4
var ATTACK_STALL = 0.5
var last_attack = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = "spawn"
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
	player = get_parent().get_node("Player")	
	
func add_damage(damage: float) -> void:
	health -= damage
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
	
	if (finishedSpawnAnimation):
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play()
		spawned = true
	
	if (not spawned):
		return
	
	if (finishedDamageAnimation):
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play()
		
	if (health <= 0):
		queue_free()
	
	if (player.current_health <= 0):
		return

	var player_pos = player.global_position
	var velocity = global_position.direction_to(player_pos)

	if (Time.get_unix_time_from_system() <= last_attack + ATTACK_STALL):
		velocity = Vector2(0, 0)
		
	if (last_col):
		var col = last_col.get_collider()	
		if (col == null):
			return

		if (col.name == "Player" and velocity.x != 0 and velocity.y != 0):
			col.current_health -= 4
			
			var vel = Vector2(0, 0)
			vel.x = (col.SPEED / 2) * (velocity.x / abs(velocity.x) )
			vel.y = (col.gravity / 2) * (velocity.y / abs(velocity.y))  
			
			col.velocity = vel
			col.move_and_slide()
			
			velocity = Vector2(0, 0)
			last_attack = Time.get_unix_time_from_system()
	
	
	last_col = move_and_collide(velocity * SPEED)
	
