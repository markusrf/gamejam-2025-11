extends RigidBody3D

@export var move_force: float = 20.0
@export var torque_strength: float = 5.0
@export var torque_multiplier: float = 5.0
@export var max_angular_speed: float = 10.0
var player_size: float = 1.0
@onready var area_3d: Area3D = $Area3D
@onready var smoke: Node3D = $Smoke


func _ready():
	area_3d.connect("body_entered", _on_body_entered)
	set_size()

func _physics_process(_delta: float) -> void:
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
			smoke.visible = true
			apply_central_force(Vector3.UP * move_force * 20)
			player_size -= 0.1
			set_size()
	
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
	if body is StaticBody3D:
		player_size += body.eat_value
		mass = player_size 
		torque_strength = player_size * torque_multiplier
		set_size()
		body.queue_free()
	
	
func set_size() -> void: 
	print(player_size)
	var newScale: float = (3.0*(player_size/(4.0*PI)))**(1.0/3.0)
	var newVector: Vector3 = Vector3(newScale, newScale, newScale)
	MusicController.player_size_changed(player_size)
	
	for child in get_children():
		child.scale = newVector
	
