extends Area2D


func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		%star.play()
		PlayerData.currency += 1000 * PlayerData.player_ref.player_stats.currency_multiplier
		await get_tree().create_timer(0.5,false).timeout
		queue_free()
