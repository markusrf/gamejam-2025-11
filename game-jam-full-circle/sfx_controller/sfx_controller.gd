extends Node

@onready var jump: AudioStreamPlayer = $SFX/Jump
@onready var button: AudioStreamPlayer = $SFX/Button
@onready var eat: AudioStreamPlayer = $SFX/Eat
@onready var stretch: AudioStreamPlayer = $SFX/Stretch
@onready var fly_death: AudioStreamPlayer = $SFX/FlyDeat

var jump_players: Array
var is_jumping: bool
var current_jump_player: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_jumping = false
	current_jump_player = "Jump3"

	for child in $SFX.get_children():
		if child is AudioStreamPlayer:
			child.stream_paused = true
			if "Jump" in child.name:
				jump_players.append(child.name)



func _get_audio_node(name: String) -> AudioStreamPlayer:
	return $SFX.get_node(name)

func _play(player: String):
	var p = _get_audio_node(player)
	p.stream_paused = false
	p.volume_db = 0.0
	p.play()

func _stop(player: String):
	var p = _get_audio_node(player)
	p.volume_db = -80.0
	p.stop()

func _fade_in(player: String, duration: float = 1.0) -> void:
	var tweener = create_tween()
	var p = _get_audio_node(player)
	p.volume_db = -80.0
	tweener.tween_property(p, "volume_db", 0.0, duration)

func _fade_out(player: String, duration: float = 1.0) -> void:
	var tweener = create_tween()
	var p = _get_audio_node(player)
	p.volume_db = 0.0
	tweener.tween_property(p, "volume_db", -80.0, duration)



### Public functions

func init_player():
	print("SFX: init player")
	stop_jump()

func start_jump():
	print("SFX: start jump")
	var player = jump_players.pick_random()
	current_jump_player = player
	is_jumping = true
	_play(player)

func stop_jump():
	if is_jumping:
		print("SFX: stop jump")
		is_jumping = false
		_fade_out(current_jump_player, 1.0)

func eat_fly():
	print("SFX: eat fly")

func press_button():
	print("SFX: pressed button")

func win():
	print("SFX: win")
	start_jump()
