extends Button

var next_scene = preload("res://levels/numbered/level-1.tscn")

func _on_pressed() -> void:
	GlobalLevel.next_level()
