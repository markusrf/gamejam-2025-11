extends Node3D

func _input(_event):
	if Input.is_action_just_pressed("restart"):
		SfxController.stop_jump()
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		SfxController.stop_jump()
		GlobalLevel.switch_to_level(0)
