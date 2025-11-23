extends Node3D

@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(directional_light_3d, "light_energy", 0.04, 5)
