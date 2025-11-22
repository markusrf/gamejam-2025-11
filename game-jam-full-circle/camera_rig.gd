extends Node3D

@export var target: Node3D
@export var follow_speed: float = 8.0
@export var offset: Vector3 = Vector3(0, 4, 10)

func _physics_process(delta: float) -> void:
	if(target == null):
		return
	
	var desired_position = target.global_transform.origin + offset
	
	#global_transform.origin = desired_position
	global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)
	
	look_at(target.global_transform.origin, Vector3.UP)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
