extends Node

@onready var jump: AudioStreamPlayer = $SFX/Jump
@onready var button: AudioStreamPlayer = $SFX/Button
@onready var eat: AudioStreamPlayer = $SFX/Eat
@onready var stretch: AudioStreamPlayer = $SFX/Stretch
@onready var fly_death: AudioStreamPlayer = $SFX/FlyDeat

var jump_tweener: Tween
var button_tweener: Tween
var eat_tweener: Tween
var stretch_tweener: Tween
var fly_death_tweener: Tween

var is_jumping: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_tweener = create_tween()
	button_tweener = create_tween()
	eat_tweener = create_tween()
	stretch_tweener = create_tween()
	fly_death_tweener = create_tween()

	is_jumping = false

	for child in $SFX.get_children():
		if child is AudioStreamPlayer:
			child.stream_paused = true



func _get_audio_node(name: String):
	return $SFX.get_node(name)

func _fade_in(player: String, tweener: Tweener, duration: float = 1.0) -> void:
	tweener.tween_property(_get_audio_node(player), "volume_db", 0.0, duration)

func _fade_out(player: String, tweener: Tweener, duration: float = 1.0) -> void:
	tweener.tween_property(_get_audio_node(player), "volume_db", -80.0, duration)



### Public functions

func init_player():
	print("SFX: init player")

func start_jump():
	print("SFX: start jump")

func stop_jump():
	print("SFX: stop jump")

func eat_fly():
	print("SFX: eat fly")

func press_button():
	print("SFX: pressed button")

func win():
	print("SFX: win")
