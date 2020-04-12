extends "res://Scripts/porteBase.gd"

class_name porteSDB

func _ready():
	pass # Replace with function body.

func _input(event):
	if playerOnDoor:
		if event is InputEventKey:
			if event.pressed and !$AudioStreamPlayer3D.playing and event.scancode == KEY_U:
					$AudioStreamPlayer3D.play(0.0)
					$Timer.start(0.75)
					
func _on_Timer_EndSoundDoor():
	$AudioStreamPlayer3D.stop()
