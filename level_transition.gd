extends Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_from_black():
	animation_player.play("FadeFromBlack")
	await animation_player.animation_finished
	
func fade_to_black():
	animation_player.play("FadeToBlack")
	await animation_player.animation_finished
