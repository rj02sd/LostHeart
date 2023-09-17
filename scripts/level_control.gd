extends Node2D


func _ready():
	pass


func _process(delta):
	pass


func _on_incline_body_entered(body):
	if get_tree().get_first_node_in_group("Player") == body:
		PlayerData.must_climb = true
		body.up_direction = Vector2(-1,0)


func _on_incline_body_exited(body):
	if get_tree().get_first_node_in_group("Player") == body:
		PlayerData.must_climb = false
		body.up_direction = Vector2(0,-1)

