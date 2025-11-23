extends Node

var level: float = 0

func choose_level(selected: int):
	level = selected
	switch_to_level(level)

func next_level():
	level += 1
	switch_to_level(level)

func switch_to_level(num: float):
	level = num
	if (num == 0):
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu_3D.tscn")
	else:
		get_tree().change_scene_to_file('res://levels/numbered/level-' + str(int(level)) + '.tscn')
