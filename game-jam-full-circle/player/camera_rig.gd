extends Node3D

@export var target: Node3D
@export var follow_speed: float = 8.0
@export var offset: Vector3 = Vector3(0, 2, 5)

@export var shake_strength := 0.2
@export var shake_duration := 0.2

var _time_left := 0.0
var _original_transform

func _ready():
	_original_transform = transform

func _process(delta):
	if(target == null):
		return
	
	if _time_left > 0.0:
		_time_left -= delta
		var rand_offset = Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		transform.origin = _original_transform.origin + rand_offset
	var size_offset = offset * target.scale
	var desired_position = target.global_transform.origin + size_offset
	
	#global_transform.origin = desired_position
	global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)
	
	look_at(target.global_transform.origin, Vector3.UP)

func shake():
	_time_left = shake_duration
