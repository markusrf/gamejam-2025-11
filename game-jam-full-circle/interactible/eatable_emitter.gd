extends Node3D

@export var eatable_scene: PackedScene        # drag your Eatable scene here
@export var spawn_rate: float = 0.5           # seconds between spawns
@export var initial_burst: int = 0            # spawn X instantly on startup
@export var spawn_radius: float = 2.0         # where they appear around emitter
@export var emit_speed: float = 4.0           # initial velocity given to them

@onready var timer: Timer = $Timer


func _ready():
	timer.wait_time = spawn_rate
	timer.timeout.connect(spawn_one)
	timer.start()

	# Spawn initial burst if desired
	for i in range(initial_burst):
		spawn_one()


func spawn_one():
	if eatable_scene == null:
		push_warning("Emitter has no Eatable Scene assigned!")
		return

	# Instantiate the Eatable object
	var obj = eatable_scene.instantiate()

	# Random spawn offset around the emitter
	var ang = randf() * TAU
	var r = sqrt(randf()) * spawn_radius
	var offset = Vector3(cos(ang) * r, 0, sin(ang) * r)

	obj.global_position = global_transform.origin + offset

	# Give random direction
	var dir = Vector3(
		randf_range(-1, 1),
		randf_range(-0.5, 0.5),
		randf_range(-1, 1)
	).normalized()

	# If your Eatable uses a `velocity` variable, set it
	if obj.get("velocity") != null:
		obj.velocity = dir * emit_speed
	# Add into the scene
	get_tree().current_scene.add_child(obj)
