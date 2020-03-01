extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var bodyActionPath

var bodyAction
var opened = false
var tClosed
var tOpened
var quatClosed
var quatOpened

# Called when the node enters the scene tree for the first time.
func _ready():
	bodyAction = get_node(bodyActionPath)
	var r : Array
	r.append(self)
	$pivo/Area.connect("body_entered",bodyAction,"_on_action",r)

	#creation du Quaternion d'ouverture de porte
	quatOpened = Quat($pivo.transform.basis.rotated(Vector3.UP,deg2rad(90.0)))
	
	
func _physics_process(delta):
	if opened:
		var q = Quat($pivo.transform.basis)
		var r = q.slerp(quatOpened,0.01)
		$pivo.transform.basis = Basis(r)
		
		
			
func open():
	print("je m'ouvre'")
	opened = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
