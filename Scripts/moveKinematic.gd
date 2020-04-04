extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed:float = 12
export var gravity = -9.81
export var close = 0.5
var vectorGravity = Vector3(0,gravity,0)
var indSimplePaths = -1
var nblistPosTarget = 0
var simplePaths = PoolVector3Array()
var nextTargetPos
var nextPoint
var onMove = false
var dir : Vector3
var targetPosition : Vector3

export(NodePath) var TargetPositionPath
export(NodePath) var NavigationPath

var NavigationNode
var TargetsNode

signal matchDestination

# Called when the node enters the scene tree for the first time.
func _ready():
	#listPosTarget = get_node("/root/Spatial/targetsNode")
	NavigationNode = get_node(NavigationPath)
	TargetsNode = get_node(TargetPositionPath)
	#nblistPosTarget = TargetsNode.get_child_count()
	nextTargetPos = $".".translation
	simplePaths.empty()
	nextPoint = translation
	
	#animation
	
	$AnimationPlayer.connect("animation_finished",self,"_on_AnimationPlayer_animation_finished")
	$AnimationPlayer.play("Idle",-1,0.8)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func getNewTargetPosition():
	
	#if nblistPosTarget > 0:
	#	var random = RandomNumberGenerator.new()
	#	random.randomize()
	#	var nb = random.randi_range(0,nblistPosTarget - 1)
	#	return TargetsNode.get_child(nb).translation
	#else:
	#	return null
	
func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play(anim_name)

func getSimpleNavigationPath(newTargetPosition):
	simplePaths.empty()
	print("translation: " , translation)
	print("newTargetPosition: " , newTargetPosition)
	simplePaths = NavigationNode.get_simple_path(translation,newTargetPosition)
	indSimplePaths = -1
	if simplePaths.size() != 0:
		nextPoint = getNextPointPath()
		onMove = true
	
	#for s in simplePaths:
	#	createBall(s)
	
	

func getNextPointPath():
	indSimplePaths+=1
	if indSimplePaths < simplePaths.size(): 
		return simplePaths[indSimplePaths]
	else:
		return translation
	
	

func _physics_process(delta):
		

	if onMove and translation.distance_to(nextPoint) < close:
		if translation.distance_to(targetPosition) < close:
			onMove = false
		else:
			nextPoint = getNextPointPath()	
			
				
	# deplacement
	dir = Vector3.ZERO
	if onMove:
		dir = translation.direction_to(nextPoint)
		dir = dir.normalized()
		if dir.length() < close:
			onMove = false
			emit_signal("matchDestination")
		
	move_and_slide((dir * speed) + vectorGravity)
		
	if dir.x != 0 and dir.z != 0:
		var angle = atan2(dir.x,dir.z)
		var char_rot = get_rotation()
		char_rot.y = lerp(char_rot.y,angle,0.05)
		set_rotation(char_rot)
		$AnimationPlayer.play("Walk",-1,0.8)
	else:
		$AnimationPlayer.play("Idle",-1,0.8)
		
	

	
func setTargetPosition(position):
	targetPosition = position
	targetPosition.y += 1
	#createBall(targetPosition)
	getSimpleNavigationPath(targetPosition)
	
func createBall(position):
	var m = MeshInstance.new()
	m.translation = position
	m.mesh = SphereMesh.new()
	get_tree().get_root().get_node('Spatial').add_child(m)
	
func _on_action(value):
	print("monser door !!!!")

