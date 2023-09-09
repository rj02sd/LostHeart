extends AudioStreamPlayer2D


func _ready():
	pass 


func _process(delta):
	if PlayerData.in_game == true:
		MusicPlayer.playing = false
		stream_paused = true
	else:
		if not MusicPlayer.playing:
			MusicPlayer.playing = true
		stream_paused = false
		
