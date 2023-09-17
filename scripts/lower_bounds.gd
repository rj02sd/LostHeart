extends Area2D


func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		body.player_stats.health = 0
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Enemy":
		body.health = 0
