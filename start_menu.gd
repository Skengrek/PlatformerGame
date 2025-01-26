extends MarginContainer
@onready var start_game: Button = %StartGame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game.grab_focus()


func _on_start_game_pressed() -> void:
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://level_one.tscn")
	LevelTransition.fade_from_black()

func _on_quit_pressed() -> void:
	get_tree().quit()
