extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	var nb_hearts = get_tree().get_node_count_in_group("Hearts")
	if nb_hearts == 1:
		Events.level_completed.emit()
