extends RigidBody3D

@export var move_force: float = 20.0
@export var torque_strength: float = 5.0
@export var torque_multiplier: float = 5.0
@export var max_angular_speed: float = 10.0
@export var camera_rig: Node3D
var player_size: float = 1.0
@onready var area_3d: Area3D = $Area3D
@onready var smoke: Node3D = $Smoke
@onready var you_won: Node2D = $"../YouWon"


var win: bool = false

func _ready():
	area_3d.connect("body_entered", _on_body_entered)
	set_size()

func _physics_process(_delta: float) -> void:
	if (player_size >= 100):
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
		if(player_size > 5):
			jump(0.1)
	
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

func grow_player(body):
	if body is RigidBody3D:
		player_size += body.eat_value
		set_size()
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

func jump(shrink: float):
	smoke.visible = true
	apply_central_force(Vector3.UP * move_force * 20)
	player_size -= shrink
	set_size()
