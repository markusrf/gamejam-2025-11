extends Node

var players: Array[AudioStreamPlayer] = []
var loop_length: float = 0.0
var last_position: float = 0.0
var scheduled_actions: Array = []
var audio_started := false


func _ready():
	# Collect all AudioStreamPlayers
	for child in $MusicTracks.get_children():
		if child is AudioStreamPlayer:
			var p := child as AudioStreamPlayer
			players.append(p)
			p.volume_db = -80.0  # muted start

	if players.is_empty():
		push_warning("No AudioStreamPlayers found under MusicTracks.")
		return

	loop_length = players[0].stream.get_length()

	print("Music initialized. Waiting for user interaction to start.")
	# ⚠️ DO NOT PLAY AUDIO YET (HTML5 AUTOPLAY BLOCK)


func _input(event):
	# Start audio only after user interaction (HTML5 requirement)
	if not audio_started and (event is InputEventMouseButton or event is InputEventKey):
		audio_started = true
		play_all()
		init_music()
		print("Music started!")


func _process(delta):
	if not audio_started or players.is_empty():
		return
	
	var pos := players[0].get_playback_position()

	if pos < last_position:  # Loop wrapped
		on_loop_point()

	last_position = pos



### --------------
### LOOP PROCESSING
### --------------

func on_loop_point():
	for action in scheduled_actions:
		action.call()
	scheduled_actions.clear()



### --------------
### HELPERS
### --------------

func get_audio_node(name_: String) -> AudioStreamPlayer:
	return $MusicTracks.get_node(name_) as AudioStreamPlayer



### ---------------------------------------------------
### LOOP-SYNCHRONIZED AUDIO COMMANDS (SAFE FOR WEB)
### ---------------------------------------------------

func play_instrument_next_loop(instrument_name: String):
	scheduled_actions.append(func():
		var p := get_audio_node(instrument_name)
		p.volume_db = 0.0
	)


func mute_instrument_next_loop(instrument_name: String):
	scheduled_actions.append(func():
		var p := get_audio_node(instrument_name)
		p.volume_db = -80.0
	)


func fade_in_instrument_next_loop(instrument_name: String, duration: float = 1.0):
	scheduled_actions.append(func():
		var p := get_audio_node(instrument_name)
		if not p.playing:
			p.play()
		fade_in(p, duration)
	)


func fade_out_instrument_next_loop(instrument_name: String, duration: float = 1.0):
	scheduled_actions.append(func():
		var p := get_audio_node(instrument_name)
		if not p.playing:
			p.play()
		fade_out(p, duration)
	)



### --------------
### CORE CONTROLS
### --------------

func play_all():
	# Start all stems EXACTLY in sync using WebAudio-safe time scheduling
	var start_time := AudioServer.get_time_to_next_mix()

	for p in players:
		p.volume_db = -80.0
		p.play(start_time)

	last_position = 0.0


func stop_all():
	for p in players:
		p.stop()


func mute_all():
	for p in players:
		p.volume_db = -80.0


func mute_all_next_loop():
	for p in players:
		var pp := p  # capture local reference
		scheduled_actions.append(func():
			pp.volume_db = -80.0
		)


func set_instrument_volume(name_: String, volume_db: float):
	var p := get_audio_node(name_)
	p.volume_db = volume_db



### --------------
### FADES
### --------------

func fade_in(player: AudioStreamPlayer, duration: float = 1.0):
	var tween := create_tween()
	tween.tween_property(player, "volume_db", 0.0, duration)


func fade_out(player: AudioStreamPlayer, duration: float = 1.0):
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -80.0, duration)



### --------------------
### GAME → MUSIC LOGIC
### --------------------

func init_music():
	set_instrument_volume("Shaker1", 0)
	set_instrument_volume("Shaker2", 0)


func player_size_changed(new_size):
	# Reset everything each loop
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
