extends Button

var next_scene = preload("res://levels/test_level.tscn")

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
