extends RigidBody2D


# Called when the node enters the scene tree for the first time.
var speed = 800
var lastCollition = null
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent()
	var player_pos = player.global_position
	
	var velocity = Vector2(0, 0)
	if (not lastCollition):
		velocity.x = speed * delta
		velocity.y = 0
	else:
		queue_free()
	lastCollition = move_and_collide(velocity)
	print(lastCollition)	
		
	pass
