extends Spatial

class_name porteBase

var player
var playerOnDoor = false
func _ready():
	player = get_node("/root/Spatial/Player")	
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
	

