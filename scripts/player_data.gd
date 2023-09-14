extends Node

var character_created = false
var class_selected
var username
var look
var difficulty
var in_game = false
var must_climb = false
var currency = 0
var checkpoint = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
var levels_completed = 0
var relic_equipped = -1
var relics = ["None","None","None","None"]
var level_upgrades = [1,1,1,1,1]
var game_started = false

func _ready():
	if get_tree().get_first_node_in_group("Player"):
		checkpoint =  get_tree().get_first_node_in_group("Player").global_position

func reset_game():
	difficulty = null
	class_selected = null
	character_created = null
	game_started = false
	level_upgrades = [1,1,1,1,1]
	checkpoint = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
	levels_completed = 0
	checkpoint = []
	currency = 0
	must_climb = false
	relics = ["None","None","None","None"]
	relic_equipped = -1
	in_game = false
	username = null
	look = null


func _process(delta):
	pass
