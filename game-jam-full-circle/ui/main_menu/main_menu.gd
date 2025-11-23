extends Control

func _ready():
	level_select_hide()

func _on_level_select_pressed() -> void:
	level_select_show()

func level_select_show():
	$start_screen.hide()
	$level_select.show()

func level_select_hide():
	$start_screen.show()
	$level_select.hide()

func _on_select_level_pressed() -> void:
	level_select_show()

func _on_back_pressed() -> void:
	level_select_hide()
