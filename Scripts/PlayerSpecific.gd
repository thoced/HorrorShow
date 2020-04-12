extends "res://Scripts/KinematicBody.gd"

class_name PlayerSpecific

# Sound
var playIsDone = false
var playerSound
var audioDoor

#Inventaire
var inventaire:Array setget ,getInventaire

func _ready():
	playerSound = get_parent().get_node("PlayerSound")
	playerSound.connect("finished",self,"finish_sound")
	inventaire.append("KEY01")
		
func _process(delta):
	if onMove and !playIsDone:
		playerSound.play(1.0)
		playIsDone = true
	
	if !onMove:	
		playerSound.stop()
		playIsDone = false
	
func finish_sound():
	playIsDone = false
	
func getInventaire():
	return inventaire

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
