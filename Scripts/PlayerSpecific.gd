extends "res://Scripts/KinematicBody.gd"

class_name PlayerSpecific

# Sound
var playIsDone = false
var playerSound
var audioDoor
var streamPasParquet = load("res://Sons/pas.wav")
var streamPasHerbe = load("res://Sons/pasHerbe.wav")

#Inventaire
var inventaire:Array setget ,getInventaire

func _ready():
	playerSound = $AudioPasParquet
	playerSound.stream = streamPasHerbe
	playerSound.connect("finished",self,"finish_sound")
		
func _process(delta):
	
	if onMove and !playIsDone:
		playerSound.play(1.0)
		playIsDone = true
	
	if !onMove:	
		playerSound.stop()
		playIsDone = false
		
func changeSoundPas(nameSound):
	match nameSound:
		"PARQUET":
			playerSound.stream = streamPasParquet
		"HERBE":
			playerSound.stream = streamPasHerbe
		_:
			playerSound.stream = streamPasHerbe

func finish_sound():
	playIsDone = false
	
func getInventaire():
	return inventaire
	
func getPick():
	var ray_lenght = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = $NodeCamera/Camera.project_ray_origin(mouse_pos)
	var to = $NodeCamera/Camera.project_ray_normal(mouse_pos) * ray_lenght
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result.size() > 0:
		return result

func getTypeGround():
	var ray_lenght = 100
	var mouse_pos = get_viewport().get_mouse_position()
	var from = transform.origin
	var to = transform.origin + (Vector3(0,-1,0) * ray_lenght)
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result.size() > 0:
		return result
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
