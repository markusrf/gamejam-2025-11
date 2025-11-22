extends Node3D

@export var duplicate_count: int = 200
@export var area_size: float = 20.0   # random placement range
@export var height: float = -2.5      # keep all cones at same Y
@export var min_spacing: float = 0.1     # minimum distance between cones

var placed_positions: Array = []


func _ready():
	randomize()

	var template = $ConeTemplate

	for i in range(duplicate_count):
		var pos = get_non_overlapping_position()

		var new_cone = template.duplicate()
		new_cone.position = pos
		add_child(new_cone)

func get_non_overlapping_position() -> Vector3:
	var attempts := 0
	var max_attempts := 500

	while attempts < max_attempts:
		attempts += 1

		var x = randf_range(-area_size, area_size)
		var z = randf_range(-area_size, area_size)
		var y = randf_range(height-0.1, height + 0.1)

		var candidate = Vector3(x, y, z)

		var ok = true
		for p in placed_positions:
			if p.distance_to(candidate) < min_spacing:
				ok = false
				break

		if ok:
			placed_positions.append(candidate)
			return candidate

	# Fallback if area is too full
	var fallback := Vector3(0, height, 0)
	placed_positions.append(fallback)
	return fallback
