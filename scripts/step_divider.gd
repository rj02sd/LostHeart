extends Area2D

@export var next_part:int

func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body):
	if get_tree().get_first_node_in_group("Player") == body:
		body.part_of_level = next_part
