extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 12
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

var tScriptMovement


# Called when the node enters the scene tree for the first time.
func _ready():
	#listPosTarget = get_node("/root/Spatial/targetsNode")
	NavigationNode = get_node(NavigationPath)
	TargetsNode = get_node(TargetPositionPath)
	#nblistPosTarget = TargetsNode.get_child_count()
	nextTargetPos = $".".translation
	simplePaths.empty()
	nextPoint = translation
	
	tScriptMovement = Thread.new()
	tScriptMovement.start(self,"runScriptMovement","")
	
func runScriptMovement(userData):
	
	var door01  = get_node("/root/Spatial/door3")
	var door02  = get_node("/root/Spatial/door")
	var lumiere:OmniLight = get_node("/root/Spatial/superhouse/lumiere")
	
	yield(get_tree().create_timer(9.0),"timeout")
	call_deferred("setTargetPosition",Vector3(23.309483, 3.20568, 27.120047))
	yield(self,"matchDestination")
	call_deferred("setTargetPosition",Vector3(23.554092, 3.20568, 24.268576))
	yield(self,"matchDestination")
	call_deferred("setTargetPosition",Vector3(24.211824, 3.20568, 23.98794))
	yield(self,"matchDestination")
	
	# ouverture de la première porte
	door01.open()
	yield(get_tree().create_timer(4.0),"timeout")
	
	#fermeture de la lumière
	lumiere.visible = false
	
	call_deferred("setTargetPosition",Vector3(16.480085, 3.20568, 24.153437))
	
	#ouverture de la seconde porte
	door02.open()
	
	var i = 0
	for i in range(1000):
		lumiere.visible = !lumiere.visible
		yield(get_tree().create_timer(0.05),"timeout")
		
	

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

