extends StaticBody2D

var armed = false
var pusher = preload("res://prefabs/enemies/pusher.tscn")

func _ready():
	pass


func _process(delta):
	pass


func _on_range_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		armed = true
		body.scared = true
		await get_tree().create_timer(0.5,false).timeout
		if armed == true:
			var hand = pusher.instantiate()
			hand.global_position = global_position
			get_parent().add_child(hand)



func _on_range_body_exited(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		armed = false
		body.scared = false
