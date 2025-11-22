extends Node3D

func _input(_event):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
