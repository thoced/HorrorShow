extends "res://Scripts/KinematicBody.gd"

# Sound
var playIsDone = false
var playerSound
var audioDoor

func _ready():
	playerSound = get_parent().get_node("PlayerSound")
	playerSound.connect("finished",self,"finish_sound")
	
func _process(delta):
	if onMove and !playIsDone:
		playerSound.play(1.0)
		playIsDone = true
	
	if !onMove:	
		playerSound.stop()
		playIsDone = false
	
func finish_sound():
	playIsDone = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
