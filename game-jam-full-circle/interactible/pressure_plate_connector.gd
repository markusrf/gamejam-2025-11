extends Node3D

signal plate_pressed()
@export var req_weight: float = 0

func _ready():
	var plate = get_node("Area3D")
	plate.connect("button_pressed", _on_button_pressed)

func _on_button_pressed():
	emit_signal("plate_pressed")
