extends CanvasLayer


func _ready():
	pass


func _process(delta):
	if PlayerData.won_game:
		%Time.text = "YOUR TIME| "+PlayerData.player_time
