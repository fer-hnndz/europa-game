extends RigidBody2D


# Called when the node enters the scene tree for the first time.
var speed = 150
var lastCollition = null
var objective = null
func _ready():
	pass # Replace with function body.

func setObjective(v: Vector2):
	objective = v
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if (objective == null):
		print("Objective is null. Not processing")
		return
	
#	if (not $VisibleOnScreenNotifier2D.is_on_screen()):
#		print("Not on screen. Deleting...")
#		queue_free()
#		return
		
	var velocity = Vector2(0, 0)
	print(objective)
	if (not lastCollition):
		
		var dir_x = 0
		var dir_y = 0
		
		if (objective.x > 0):
			dir_x = 1
		else:
			dir_x = -1;
			
			
		if (abs(objective.y) >= 25):
			objective.y = 0
		if (objective.y > 0):
			dir_y = 1
		else:
			dir_y = -1;
			
		velocity.x = dir_x * speed * delta
		velocity.y = dir_y * speed * delta
	else:
		queue_free()
	
	velocity.normalized()
	lastCollition = move_and_collide(velocity)
	pass
