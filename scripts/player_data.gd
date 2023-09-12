extends Node

var in_game = false
var must_climb = false
var currency = 0
var checkpoint:Vector2

func _ready():
	if get_tree().get_first_node_in_group("Player"):
		checkpoint =  get_tree().get_first_node_in_group("Player").global_position


func _process(delta):
	pass
