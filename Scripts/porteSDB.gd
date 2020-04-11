extends Spatial
var player
var actions
var playerOnDoor = false
var soundDoor
var audioStream
func _ready():
	player = get_node("/root/Spatial/Player")	
	var userData = [self,actions]
	$Area.connect("body_entered",self,"_on_body_entered")
	$Area.connect("body_exited",self,"_on_body_exited")

func _on_body_entered(body):
	if body == player:
		print("Player est devant la porte")
		playerOnDoor = true
		
func _on_body_exited(body):
	if body == player:
		print("Player n'est plus devant la porte")
		playerOnDoor = false
		
	
func _input(event):
	if playerOnDoor:
		if event is InputEventKey:
			if event.pressed and !$AudioStreamPlayer3D.playing and event.scancode == KEY_U:
					$AudioStreamPlayer3D.play(0.0)
					$Timer.start(0.75)
			
func _process(delta):
	pass

func _on_Timer_EndSoundDoor():
	$AudioStreamPlayer3D.stop()
