extends RigidBody3D

@export var move_force: float = 20.0
@export var torque_strength: float = 5.0
@export var max_angular_speed: float = 10.0


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
		#apply_central_force(direction * move_force)
		var torque: Vector3 = direction.cross(Vector3.UP) * torque_strength
		apply_torque(torque)
	
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var ang_vel = state.angular_velocity
	var ang_speed = ang_vel.length()
	
	if(ang_speed > max_angular_speed):
		ang_vel = ang_vel.normalized() * max_angular_speed
		state.angular_velocity = ang_vel 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
