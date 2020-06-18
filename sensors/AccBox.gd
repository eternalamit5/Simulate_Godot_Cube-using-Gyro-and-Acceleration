extends KinematicBody


# Declare member variables here. 
var velocity = Vector3(0,0,0)
var start_pos = Vector3()
var position = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = translation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func moveBox(acc, delta):
	velocity.x += acc.x * delta
	velocity.y += acc.y * delta
	velocity.z += acc.z * delta 
	
	position.x += velocity.x * delta
	position.y += velocity.y * delta
	position.z += velocity.z * delta 
	
#	print("position.X: ")
#	print(position.x)
	if position.x >= 2 :
		position.x = 2
		print("Max platform position reached in +X direction: ")
		print(position.x)
		velocity.x=0
#		
	elif position.x <= -2:
		position.x = 2
		print("Max platform position reached in -X direction: ")
		print(position.x)
		velocity.x=0
		
	if position.y >= 2 :
		position.y = 2
		print("Max platform position reached in +Y direction: ")
		print(position.y)
		velocity.y=0
#		move_and_slide(velocity)
	elif position.y <= -2:
		position.y = 2
		print("Max platform position reached in -Y direction: ")
		print(position.y)
		velocity.y=0
		
	if position.z >= 2 :
		position.z = 2
		print("Max platform position reached in +Z direction: ")
		print(position.z)
		velocity.z=0
#		
	elif position.z <= -2:
		position.z = 2
		print("Max platform position reached in -Z direction: ")
		print(position.z)
		velocity.z=0
	
	move_and_slide(velocity)
	
	
#	get_node(".").translate(Vector3(0,0,0))
#	print("printing node position in X: ")
#	print(get_node(".").translation.x)
	
	##################################
#	var previoustime=0
#	var currenttime= OS.get_time()
#	while(true):
#		previoustime=currenttime
#		currenttime=OS.get_time()
#		var dt=currenttime-previoustime
#		if(dt > 0.15):
#			dt=0.15
#		update(dt)
		###############################33
#	if ((translation.x >= 2 || translation.x >= -2)||(translation.y >= 2 || translation.y >= -2)||(translation.z >= 2 || translation.z >= -2)):
#		translate(start_pos)
#	if ((position.x >= 2 || position.x >= -2)||(position.y >= 2 || position.y >= -2)||(position.z >= 2 || position.z >= -2)):
#		translate(position)
#	if translation.x >= 1 || translation.x >= -1:
#		translate(start_pos)
#	if translation.x >= 1 || translation.x >= -1:
#		translate(start_pos)
#	elif translation.z >= 2 || translation.z >= -2:
#		translate(start_pos)
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
