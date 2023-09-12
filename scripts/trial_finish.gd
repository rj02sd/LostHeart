extends Area2D


func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		%level_complete.visible = true
		PlayerData.in_game = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
