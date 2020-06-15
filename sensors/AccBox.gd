extends KinematicBody


# Declare member variables here. 
var velocity = Vector3(0,0,0)
var start_pos = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = translation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func moveBox(acc, delta):
	velocity.x += acc.x * delta
	velocity.y += acc.y * delta
	velocity.z += acc.z * delta 
	
	
	
	move_and_slide(velocity)
#	get_node(".").translate(Vector3(0,0,0))
	print(get_node(".").translation.x)
	
	if translation.x >= 2 || translation.x >= -2 :
		translate(start_pos)
	
#	velocity.x = lerp(velocity.x, 0, 1)
#	velocity.y = lerp(velocity.y, 0, 1)
#	velocity.z = lerp(velocity.z, 0, 1)
	
#	if Input.is_action_pressed("move_right"):
#		velocity.x = SPEED
#	elif Input.is_action_pressed("move_left"):
#		velocity.x = -SPEED
#	else:
#		velocity.x = lerp(0, 0, 0.1)
#
#	if Input.is_action_pressed("move_up"):
#		velocity.y = +SPEED
#	elif Input.is_action_pressed("move_down"):
#		velocity.y = -SPEED
#	else:
#		velocity.y = lerp(velocity.y, 0, 0.1)
