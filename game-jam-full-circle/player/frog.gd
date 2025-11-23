extends RigidBody3D

@export var move_force: float = 15.0
@export var torque_strength: float = 5.0
@export var torque_multiplier: float = 5.0
@export var max_angular_speed: float = 10.0
@export var camera_rig: Node3D
var player_size: float = 1.0
@onready var area_3d: Area3D = $Area3D
@onready var smoke: Node3D = $Smoke
@onready var you_won: Node2D = $"../YouWon"

signal size_changed(player_size: float)


var win: bool = false


func _ready():
	area_3d.connect("body_entered", _on_body_entered)
	set_size()
	SfxController.init_player()

func _physics_process(_delta: float) -> void:
	if (player_size >= 100):
		if win != true:
			SfxController.win()
		win = true
		you_won.visible = true
	if (win):
		if (camera_rig != null):
			camera_rig.shake()
		move_force = 100
		jump(0)
		return

	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y += 1.0
	if Input.is_action_pressed("move_back"):
		input_vector.y -= 1.0
	if Input.is_action_pressed("move_left"):
		input_vector.x += 1.0
	if Input.is_action_pressed("move_right"):
		input_vector.x -= 1.0
	smoke.visible = false
	if Input.is_action_pressed("jump"):
		if(player_size > 1.5):
			if Input.is_action_just_pressed("jump"):
				SfxController.start_jump()
			jump(0.1)
		else:
			SfxController.stop_jump()
	if Input.is_action_just_released("jump"):
		SfxController.stop_jump()
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		
	var direction = Vector3.ZERO
	direction.x = input_vector.x
	direction.z = input_vector.y
	
	if(direction != Vector3.ZERO):
		
		var torque: Vector3 = direction.cross(Vector3.UP) * torque_strength
		apply_torque(torque)
	
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var ang_vel = state.angular_velocity
	var ang_speed = ang_vel.length()
	
	if(ang_speed > max_angular_speed):
		ang_vel = ang_vel.normalized() * max_angular_speed
		state.angular_velocity = ang_vel 

func _on_body_entered(body: PhysicsBody3D):
	grow_player(body)

func capsule_volume(r, h) -> float:
	
	return PI * r * r * h + (4.0 / 3.0) * PI * pow(r, 3)
	
func grow_player(body):
	if not ("eat_value" in body):
		return

	# Find capsule shape
	var shape: CapsuleShape3D = null
	for child in body.get_children():
		if child is CollisionShape3D and child.shape is CapsuleShape3D:
			shape = child.shape
			break

	if shape == null:
		return

	var S = body.scale.x
	var r = shape.radius * S * body.newScale
	var h = shape.height * S * body.newScale

	# Call the function directly, NOT via body
	var eatable_size = capsule_volume(r, h) * 1.1
	print_debug("eatable_size ", eatable_size)
	print_debug("player_size ",player_size)
	if player_size >= eatable_size:
		player_size += body.eat_value
		set_size()
		SfxController.eat_fly()
		body.queue_free()


	
func set_size() -> void: 
	print_debug(player_size)
	var newScale: float = (3.0*(player_size/(4.0*PI)))**(1.0/3.0)
	var newVector: Vector3 = Vector3(newScale, newScale, newScale)
	MusicController.player_size_changed(player_size)
	mass = player_size 
	torque_strength = player_size * torque_multiplier
	
	for child in get_children():
		child.scale = newVector
	emit_signal("size_changed", player_size)

func jump(shrink: float):
	smoke.visible = true
	#var force = Vector3.UP * move_force * player_size
	#print_debug(force)
	var accel := Vector3(0, move_force, 0)
	apply_central_force(accel * mass)
	#apply_central_force(force)
	player_size -= shrink
	set_size()
	
	
# Unused
func fun_jump(strength: float):
	smoke.visible = true

	# Forward direction along player's +Z
	var forward = global_transform.basis.z.normalized()  # use +Z instead of -Z
	
	# Combine forward and upward motion
	var jump_force = forward * move_force + Vector3.UP * move_force

	# Apply the force proportional to mass
	apply_central_force(jump_force * mass)

	# Shrink player if needed
	player_size -= strength
	set_size()
