extends Node

var animationPlayer

func _ready():
	animationPlayer = get_parent().get_node("AnimationPlayer")
	animationPlayer.connect("animation_finished",self,"_on_AnimationPlayer_animation_finished")
	animationPlayer.play("Walk",-1,2)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	animationPlayer.play(anim_name)
