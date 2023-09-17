extends CanvasLayer

var old_game_scene = preload("res://scenes/level_select.tscn")
var new_game_scene = preload("res://scenes/difficulty_selection.tscn")

func _ready():
	pass


func _process(delta):
	pass


func _on_play_pressed():
	if not PlayerData.character_created:
		get_tree().change_scene_to_packed(new_game_scene)
		PlayerData.character_created = true
	else:
		get_tree().change_scene_to_packed(old_game_scene)


func _on_controls_pressed():
	%controls.visible = true


func _on_credits_pressed():
	%credits.visible = true
	MusicPlayer.volume_db = -INF
	%credits_music.play()
	


func _on_tutorial_pressed():
	%tutorial.visible = true
