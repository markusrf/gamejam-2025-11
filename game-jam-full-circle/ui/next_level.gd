extends Button

@export var level: float = 1

func _on_pressed() -> void:
	SfxController.stop_jump()
	GlobalLevel.next_level()
