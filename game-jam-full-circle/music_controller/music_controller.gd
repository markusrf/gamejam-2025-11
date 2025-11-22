extends Node

var players: Array[AudioStreamPlayer] = []
var loop_length: float
var last_position: float = 0.0
var scheduled_actions: Array = []

func _ready():
	loop_length = $MusicTracks/Lead1.stream.get_length()
	# Collect all players automatically
	for child in $MusicTracks.get_children():
		if child is AudioStreamPlayer:
			players.append(child)
			child.stream_paused = true
			child.volume_db = -80

	play_all()
	init_music()

func _process(delta):
	if players.is_empty():
		return

	# All stems are identical duration, so pick the first one
	var pos := players[0].get_playback_position()

	# If wrapping around (pos < last_position), the loop restarted
	if pos < last_position:
		on_loop_point()

	last_position = pos




### Core audio functions for controlling the music

func on_loop_point():
	# This function is called on the first frame that hapens
	# after the music has looped
	print_debug("processing scheduled events: ", scheduled_actions.size())
	for action in scheduled_actions:
		action.call()
	scheduled_actions.clear()

func get_audio_node(name: String):
	return $MusicTracks.get_node(name)

func play_instrument_next_loop(instrument_name: String):
	scheduled_actions.append(func():
		get_audio_node(instrument_name).volume_db = 0.0
	)

func mute_instrument_next_loop(instrument_name: String):
	scheduled_actions.append(func():
		get_audio_node(instrument_name).volume_db = -80.0
	)

func fade_in_instrument_next_loop(instrument_name: String, duration: float = 1.0) -> void:
	scheduled_actions.append(func ():
		var p := get_audio_node(instrument_name) as AudioStreamPlayer
		# make sure it's playing and muted
		if not p.playing:
			p.play(0)
			p.stream_paused = false
		fade_in(p, duration)
	)

func fade_out_instrument_next_loop(instrument_name: String, duration: float = 1.0) -> void:
	scheduled_actions.append(func ():
		var p := get_audio_node(instrument_name) as AudioStreamPlayer
		# make sure it's playing and muted
		if not p.playing:
			p.play(0)
			p.stream_paused = false
		fade_out(p, duration)
	)

func play_all():
	# Ensure all players start on the **same audio frame**
	for p in players:
		p.stream_paused = false
		p.play()

func stop_all():
	for p in players:
		p.stop()

func mute_all():
	for p in players:
		p.volume_db = -80.0

func mute_all_next_loop():
	for p in players:
		scheduled_actions.append(func():
			p.volume_db = -80.0
		)

func set_instrument_volume(name: String, volume_db: float):
	var p = get_audio_node(name)
	p.volume_db = volume_db

func fade_in(player: AudioStreamPlayer, duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(player, "volume_db", 0.0, duration)


func fade_out(player: AudioStreamPlayer, duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -80.0, duration)





### Game logic functions affecting the music

func init_music():
	set_instrument_volume("Shaker1", 0)
	set_instrument_volume("Shaker2", 0)
	play_instrument_next_loop("Lead1Add1")

func player_size_changed(new_size):
	mute_all_next_loop()
	play_instrument_next_loop("Shaker1")
	play_instrument_next_loop("Shaker2")

	if new_size < 5.0:
		play_instrument_next_loop("Lead1Add1")

	if new_size >= 5.0 and new_size < 10.0:
		play_instrument_next_loop("Conga1")
		play_instrument_next_loop("Lead1")

	if new_size >= 10.0 and new_size < 20.0:
		play_instrument_next_loop("Conga1")
		play_instrument_next_loop("Bass1")
		play_instrument_next_loop("Lead1Sub1")

	if new_size >= 20.0:
		play_instrument_next_loop("Conga1")
		play_instrument_next_loop("Bass1")
		play_instrument_next_loop("Lead1Sub2")
