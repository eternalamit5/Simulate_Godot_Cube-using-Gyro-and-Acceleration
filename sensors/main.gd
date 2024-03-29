extends Node
#Amit
# Below are a number of helper functions that show how you can use the raw sensor data to determine the orientation 
# of your phone/device. The cheapest phones only have an accelerometer only the most expensive phones have all three.
# Note that none of this logic filters data. Filters introduce lag but also provide stability. There are plenty
# of examples on the internet on how to implement these. I wanted to keep this straight forward.

# We draw a few arrow objects to visualize the vectors and two cubes to show two implementation for orientating 
# these cubes to our phones orientation.
# This is a 3D example however reading the phones orientation is also invaluable for 2D

# This function calculates a rotation matrix based on a direction vector. As our arrows are cylindrical we don't
# care about the rotation around this axis.



func get_basis_for_arrow(p_vector):
	var rotate = Basis()
	
	# as our arrow points up, Y = our direction vector
	rotate.y = p_vector.normalized()
	
	# get an arbitrary vector we can use to calculate our other two vectors
	var v = Vector3(1.0, 0.0, 0.0)
	if (abs(v.dot(rotate.y)) > 0.9):
		v = Vector3(0.0, 1.0, 0.0)
	
	# use our vector to get a vector perpendicular to our two vectors
	rotate.x = rotate.y.cross(v).normalized()
	
	# and the cross product again gives us our final vector perpendicular to our previous two vectors
	rotate.z = rotate.x.cross(rotate.y).normalized()
	
	return rotate
	# This function combines the magnetometer reading with the gravity vector to get a vector that points due north
func calc_north(p_grav, p_mag):
	# Always use normalized vectors!
	p_grav = p_grav.normalized()
	
	# Calculate east (or is it west) by getting our cross product.
	# The cross product of two normalized vectors returns a vector that
	# is perpendicular to our two vectors
	var east = p_grav.cross(p_mag.normalized()).normalized()
	
	# Cross again to get our horizon aligned north
	return east.cross(p_grav).normalized()

# This function creates an orientation matrix using the magnetometer and gravity vector as inputs.
func orientate_by_mag_and_grav(p_mag, p_grav):
	var rotate = Basis()
	
	# as always, normalize!
	p_mag = p_mag.normalized()
	
	# gravity points down, so - gravity points up!
	rotate.y = -p_grav.normalized()
	
	# Cross products with our magnetic north gives an aligned east (or west, I always forget)
	rotate.x = rotate.y.cross(p_mag)
	
	# And cross product again and we get our aligned north completing our matrix
	rotate.z = rotate.x.cross(rotate.y)
	
	return rotate
	# This function takes our gyro input and update an orientation matrix accordingly
# The gyro is special as this vector does not contain a direction but rather a
# rotational velocity. This is why we multiply our values with delta.
#
func rotate_by_gyro(p_gyro, p_basis, p_delta):
	var rotate = Basis()
	
	rotate = rotate.rotated(p_basis.x, -p_gyro.x * p_delta)  #it calculates angle from rot velocity, -ve is used for anti CW rotation : check
	rotate = rotate.rotated(p_basis.y, -p_gyro.y * p_delta)
	rotate = rotate.rotated(p_basis.z, -p_gyro.z * p_delta)
	
	return rotate * p_basis  # p_basis contains the previous rotation angle of the body in the matrix of 3x3

# This function corrects the drift in our matrix by our gravity vector 
func drift_correction(p_basis, p_grav):
	# as always, make sure our vector is normalized but also invert as our gravity points down
	var real_up = -p_grav.normalized()
	
	# start by calculating the dot product, this gives us the cosine angle between our two vectors
	var dot = p_basis.y.dot(real_up)
	
	#commented as functionality not needed
#	if (dot < 1.0):
#		# the cross between our two vectors gives us a vector perpendicular to our two vectors
#		var axis = p_basis.y.cross(real_up).normalized()
#		var correction = Basis(axis, acos(dot))
#		p_basis = correction * p_basis
	
	return p_basis

#-------------------------------Variables and Functions for TCP connection -------------------------------------
var connection = null
var peerstream = null
var test = null

var AsciiString = null
var TempByteArray = null
var recvMsg = null

func _ready():
	print("Started client TCP")
	# Connect
	connection = StreamPeerTCP.new()
	if(connection.connect_to_host("127.0.0.1", 8888) !=OK):
		print("an error occurred listening on port ")
		peerstream = PacketPeerStream.new()
		peerstream.set_stream_peer(connection)

func send_server():
	AsciiString = "{Client}: Requesting Data".to_ascii()
	TempByteArray = PoolByteArray(AsciiString)
	connection.put_data(TempByteArray) # sending poolbyte array to server

#--------------------Variables and Functions for SENSOR DATA String Split ---------------
var recvMsgArray = []
var recvMsgString = null
var gyro_x = 0
var gyro_y = 0
var gyro_z = 0
var acc_x = 0
var acc_y = 0
var acc_z = 0


func poll_server():
	recvMsg = connection.get_available_bytes()
#	print("recvMsg")
#	print(recvMsg)
	var msg = connection.get_utf8_string(recvMsg)
#	print("msg")
#	print(msg)
	#get_utf8_string(1)
	if(msg.empty()==false):
#		recvMsgArray.append(msg)
#		recvMsgString = PoolStringArray(recvMsgArray)
#		recvMsgStringLine = String(recvMsgString).split(",",true)
		var temp = msg
		var temp2 = Array(String(temp).split(":",true,0))
		print("temp2")
		print(temp2)
		if temp2.size() == 6:
			gyro_x = temp2[0]
			gyro_y = temp2[1] 
			gyro_z = temp[2]
			acc_x = temp2[3]
			acc_y = temp2[4]
			acc_z = temp2[5]
#			acc_x = 2
#			acc_y = 0
#			acc_z = 0
#			recvMsgArray.clear()
	
func _process(delta):
#	Requesting Data from Server
	if connection.is_connected_to_host():
		send_server()
		poll_server()
	
	# Get our data from the inbuilt device 
	var acc = Input.get_accelerometer()
	var grav = Input.get_gravity()
	var mag = Input.get_magnetometer()
	var gyro = Input.get_gyroscope()
	
#	Setting Gyro values with the data got from Server
	var gyro_velocity = Vector3(gyro_x,gyro_y,gyro_z)
	gyro = gyro_velocity

#	Setting Acceleration values with the data got from Server
	var Linear_acc = Vector3(acc_x,acc_y,acc_z)
	acc = Linear_acc
	
#	setting Accelerometer node Box values
	get_node("Boxes/AccBox").moveBox(Linear_acc, delta)
	
	
	# Show our base values
#	get_node("Control/Accelerometer").text = 'Accelerometer: ' + str(acc) + ', gravity: ' + str(grav)
#	get_node("Control/Magnetometer").text = 'Magnetometer: ' + str(mag)
	get_node("Control/Accelerometer").text = 'Accelerometer: ' + str(acc)
	get_node("Control/Gyroscope").text = 'Gyroscope: ' + str(gyro)

	
	
	# Check if we have all needed data
	if grav.length() < 0.1:
		if acc.length() < 0.1:
			# we don't have either...
			grav = Vector3(0.0, -1.0, 0.0)
		else:
			# The gravity vector is calculated by the OS by combining the other sensor inputs.
			# If we don't have a gravity vector, from now on, use accelerometer...
			grav = acc 
	
	if mag.length() < 0.1:
		mag = Vector3(1.0, 0.0, 0.0)
	
	# Update our arrow showing gravity
	get_node("Arrows/AccelerometerArrow").transform.basis = get_basis_for_arrow(grav)
	
	# Update our arrow showing our magnetometer
	# Note that in absense of other strong magnetic forces this will point to magnetic north, which is not horizontal thanks to the earth being, uhm, round
	get_node("Arrows/MagnetoArrow").transform.basis = get_basis_for_arrow(mag)
	
	# Calculate our north vector and show that
	var north = calc_north(grav,mag)
	get_node("Arrows/NorthArrow").transform.basis = get_basis_for_arrow(north)
		
	# Combine our magnetometer and gravity vector to position our box. This will be fairly accurate
	# but our magnetometer can be easily influenced by magnets. Cheaper phones often don't have gyros
	# so it is a good backup.
	var mag_and_grav = get_node("Boxes/MagAndGrav")
	mag_and_grav.transform.basis = orientate_by_mag_and_grav(mag, grav).orthonormalized()
	
	# Using our gyro and do a drift correction using our gravity vector gives the best result
	var gyro_and_grav = get_node("Boxes/GyroAndGrav")
	var new_basis = rotate_by_gyro(gyro, gyro_and_grav.transform.basis, delta).orthonormalized()
	gyro_and_grav.transform.basis = drift_correction(new_basis, grav)
	#get_node("Boxes/AccBox").moveBox(Linear_acc, delta)
	var gyro_acc=get_node("Boxes/AccBox")
	var new_basis1 = rotate_by_gyro(gyro, gyro_acc.transform.basis, delta).orthonormalized()
	gyro_acc.transform.basis = drift_correction(new_basis, grav)
	
	#get_node("Boxes/GyroAndGrav").moveBox(Linear_acc, delta)
	
