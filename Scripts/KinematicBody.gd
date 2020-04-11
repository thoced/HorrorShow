extends KinematicBody

export var Sensitivity_X = 0.0001
export var Sensitivity_Y = 0.0001
export var Invert_Y_Axis = false
export var Exit_On_Escape = true
export var Maximum_Y_Look = 45
export var Accelaration = 5
export var Maximum_Walk_Speed = 10
export var Jump_Speed = 2

const GRAVITY = 0.098
var velocity = Vector3(0,0,0)
var forward_velocity = 0
var Walk_Speed = 0
var crounch = false
var positionDown
var positionUp
var bananeCenter
var bananeLeft
var bananeRight

# Sound
var forwardPressed = false
var playIsDone = false
var playerSound
var audioDoor


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	forward_velocity = Walk_Speed
	set_process(true)
	
	positionUp = $NodeCamera.transform.origin
	positionDown = $NodeCamera.transform.origin + Vector3(0,-0.5,0)
	
	bananeCenter = $NodeCamera.transform.basis
	bananeLeft = $NodeCamera.transform.basis.rotated(Vector3.FORWARD,deg2rad(-15.0))
	bananeRight = $NodeCamera.transform.basis.rotated(Vector3.FORWARD,deg2rad(15.0))
	
	playerSound = get_parent().get_node("PlayerSound")
	playerSound.connect("finished",self,"finish_sound")
	
	audioDoor = load("res://Sons/door.wav")
	#playerSound.stream = audioDoor
	

func finish_sound():
	playIsDone = false
	

func _process(delta):
	if Exit_On_Escape:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
			
	if forwardPressed and !playIsDone:
		playerSound.play(1.0)
		playIsDone = true
	
	
	
func _physics_process(delta):
	velocity.y -= GRAVITY
	crounch = false
	forwardPressed = false
	
	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_UP):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = -global_transform.basis.z.x * Walk_Speed
		velocity.z = -global_transform.basis.z.z * Walk_Speed
		forwardPressed = true
		
		
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = global_transform.basis.z.x * Walk_Speed
		velocity.z = global_transform.basis.z.z * Walk_Speed
		forwardPressed = true
		
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_Q):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = -global_transform.basis.x.x * Walk_Speed
		velocity.z = -global_transform.basis.x.z * Walk_Speed	
		forwardPressed = true
		
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		Walk_Speed += Accelaration
		if Walk_Speed > Maximum_Walk_Speed:
			Walk_Speed = Maximum_Walk_Speed
		velocity.x = global_transform.basis.x.x * Walk_Speed
		velocity.z = global_transform.basis.x.z * Walk_Speed
		forwardPressed = true
		
	if not(Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_RIGHT)):
		velocity.x = 0
		velocity.z = 0
		playerSound.stop()
		playIsDone = false
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = Jump_Speed
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	#crounch
	if Input.is_key_pressed(KEY_CONTROL):
		crounch = true
		var vNew = $NodeCamera.transform.origin.linear_interpolate(positionDown,0.1)
		$NodeCamera.transform.origin = vNew
	else:
		var vNew = $NodeCamera.transform.origin.linear_interpolate(positionUp,0.1)
		$NodeCamera.transform.origin = vNew
		
	#banane
	if Input.is_key_pressed(KEY_A):
		var vNew = $NodeCamera.transform.basis.slerp(bananeLeft,0.1)
		$NodeCamera.transform.basis = vNew
	if Input.is_key_pressed(KEY_E):
		var vNew = $NodeCamera.transform.basis.slerp(bananeRight,0.1)
		$NodeCamera.transform.basis = vNew
	elif not(Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_E)):
		var vNew = $NodeCamera.transform.basis.slerp(bananeCenter,0.1)
		$NodeCamera.transform.basis = vNew
		
		
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-Sensitivity_X * event.relative.x)
		
			
