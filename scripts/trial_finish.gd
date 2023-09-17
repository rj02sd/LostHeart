extends Area2D

@export var level_index:int

func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		%level_complete.visible = true
		PlayerData.checkpoint = Vector2.ZERO
		PlayerData.in_game = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		body.won = true
		%victory_sound.play()
		if level_index > PlayerData.highest_level_completed:
			PlayerData.highest_level_completed = level_index
			PlayerData.levels_completed += 1
