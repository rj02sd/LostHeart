extends Area2D

var in_range = false

func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("interact") and in_range:
		if get_tree().get_first_node_in_group("Pushbot"):
			get_tree().get_first_node_in_group("Pushbot").queue_free()
			queue_free()


func _on_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if get_tree().get_first_node_in_group("Interface"):
			get_tree().get_first_node_in_group("Interface").interactable = true
			in_range = true


func _on_body_exited(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if get_tree().get_first_node_in_group("Interface"):
			get_tree().get_first_node_in_group("Interface").interactable = false
			in_range = false
