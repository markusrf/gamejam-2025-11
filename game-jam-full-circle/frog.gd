extends RigidBody3D

@export var move_force: float = 20.0

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y -= 1.0
	if Input.is_action_pressed("move_back"):
		input_vector.y += 1.0
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1.0
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		
		
	var direction = Vector3.ZERO
	direction.x = input_vector.x
	direction.z = input_vector.y
	
	if(direction != Vector3.ZERO):
		apply_central_force(direction * move_force)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
