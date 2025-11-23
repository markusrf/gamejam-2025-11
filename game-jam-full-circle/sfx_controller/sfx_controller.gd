extends Node

var jump_players: Array
var is_jumping: bool
var current_jump_player: String
var current_jump_tweener: Tween
var current_fly_death_tweener: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_jumping = false
	current_jump_player = "Jump3"

	for child in $SFX.get_children():
		if child is AudioStreamPlayer:
			child.stream_paused = true
			child.volume_db = -80.0
			if "Jump" in child.name:
				jump_players.append(child.name)



func _get_audio_node(name2: String) -> AudioStreamPlayer:
	return $SFX.get_node(name2)

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
	tweener.tween_property(p, "volume_db", 0.0, duration)

func _fade_out(player: String, duration: float = 1.0) -> Tween:
	var tweener = create_tween()
	var p = _get_audio_node(player)
	tweener.tween_property(p, "volume_db", -80.0, duration)
	tweener.finished.connect(func(): p.stop())
	return tweener



### Public functions

func init_player():
	#print("SFX: init player")
	stop_jump()

func start_jump():
	#print("SFX: start jump")
	if is_jumping:
		return
	var player = jump_players.pick_random()
	current_jump_player = player
	is_jumping = true
	if current_jump_tweener and current_jump_tweener.is_valid():
		_stop(player)
		current_jump_tweener.kill()
	_play(player)

func stop_jump():
	if is_jumping:
		#print("SFX: stop jump")
		is_jumping = false
		current_jump_tweener = _fade_out(current_jump_player, 0.6)

func eat_fly():
	#print("SFX: eat fly")
	var player = "FlyDeath"
	if (randf() > 0.5):
		_play("Stretch")
	else:
		_play("Eat")
	if current_fly_death_tweener and current_fly_death_tweener.is_valid():
		_stop(player)
		current_fly_death_tweener.kill()
	_play(player)
	current_fly_death_tweener = _fade_out(player, 2.0)

func press_button():
	#print("SFX: pressed button")
	_play("Button")

func win():
	#print("SFX: win")
	#stop_jump()
	start_jump()
