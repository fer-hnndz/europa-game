extends RigidBody2D


# Called when the node enters the scene tree for the first time.
var speed = 150
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
		
		var dir_x = objective.x
		var dir_y = objective.y
		velocity.x = dir_x * delta
		velocity.y = dir_y * delta
	else:
		var col = lastCollition.get_collider()
		
		if (col == null):
			print("La ultima colision es null???")
			queue_free()			
			return
		
		if (col.get_class() == "CharacterBody2D"):
			col.add_damage(damage)
		queue_free()
		return
	
	velocity.normalized()
	lastCollition = move_and_collide(velocity)
	pass
