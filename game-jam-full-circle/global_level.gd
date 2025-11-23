extends Node

var level: float = 0

func choose_level(selected: int):
	level = selected
	switch_to_level(level)

func next_level():
	level += 1
	switch_to_level(level)

func switch_to_level(num: float):
	get_tree().change_scene_to_file('res://levels/numbered/level-' + str(int(num)) + '.tscn')
