extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	position = Vector2(randf_range(0, 1400), randf_range(0, 650))
	
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
	
	$AnimatedSprite2D2.animation = "default"
	$AnimatedSprite2D2.frame = 19
	$AnimatedSprite2D2.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= 100 * delta
	
	if (position.x < -200):
		position.x = 1400
		position.y = randf_range(80, 650)
