extends CharacterBody2D
var spawned = false
var health = 82
var player
var SPEED = 2.2

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
		return
	
	var player_pos = player.global_position
	var velocity = global_position.direction_to(player_pos)

	if not is_on_floor():
		pass
		#velocity.y += gravity * delta
	
	move_and_collide(velocity * SPEED)
	
