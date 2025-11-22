extends Node

var players: Array[AudioStreamPlayer] = []

func _ready():
	# Collect all players automatically
	for child in $MusicTracks.get_children():
		if child is AudioStreamPlayer:
			players.append(child)
			child.stream_paused = true
			child.volume_db = -80

	set_instrument_volume("Lead1", 0)
	set_instrument_volume("Shaker1", 0)

	play_all()

func play_all():
	# Ensure all players start on the **same audio frame**
	for p in players:
		p.play()

func stop_all():
	for p in players:
		p.stop()

func set_instrument_volume(name: String, volume_db: float):
	var p = $MusicTracks.get_node(name)
	p.volume_db = volume_db
