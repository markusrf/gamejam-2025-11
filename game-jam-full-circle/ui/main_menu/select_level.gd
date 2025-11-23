extends Button

@export var level_num: float = 1

func _on_pressed() -> void:
	GlobalLevel.choose_level(level_num)
