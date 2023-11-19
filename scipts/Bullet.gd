extends RigidBody2D


# Called when the node enters the scene tree for the first time.
var speed = 4
var lastCollition = null
var objective = null
var damage = 3
var stage = -1


func _ready():
	pass # Replace with function body.

func setObjective(v: Vector2):
	objective = v


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if (objective == null):
		return
	
	var velocity = Vector2(0, 0)
	if (not lastCollition):
		
		var dir_x
		var dir_y
		
		if (global_position.x - objective.x > 0):
			dir_x = speed
		if (global_position.y - objective.y > 0):
			dir_y = speed
	else:
		var col = lastCollition.get_collider()
		
		if (col == null):
			queue_free()			
			return
		
		if (col.get_class() == "CharacterBody2D"):
			col.add_damage(damage)
		queue_free()
		return
	
	velocity.normalized()
	lastCollition = move_and_collide(objective * (delta * speed))
	pass
