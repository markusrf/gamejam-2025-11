extends RigidBody3D
@export var eat_value: float = 1.0

var velocity: Vector3 = Vector3.ZERO

@export var speed: float = 4.0
@export var newScale: float = 1.0

func _physics_process(delta):
	position += velocity * delta

func _ready():
	var newVector: Vector3 = Vector3(newScale, newScale, newScale)
	
	for child in get_children():
		child.scale = newVector
