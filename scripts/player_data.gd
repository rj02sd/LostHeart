extends Node

var character_created = false
var class_selected
var username
var look
var difficulty
var in_game = false
var must_climb = false
var currency = 0
var checkpoint = Vector2.ZERO
var levels_completed = 0
var highest_level_completed = 0
var relic_equipped = -1
var divinity = 1
var relics = ["None","None","None","None"]
var level_upgrades = [1,1,1,1,1]
var game_started = false
var won_game = false
var player_class
var player_ref
var player_time = ""

var mins = 0
var seconds = 0


'''
level upgrades are:
	health
	spirit and spirit regen
	resistance
	speed
	overall damage
'''

func _ready():
	if get_tree().get_first_node_in_group("Player"):
		player_ref = get_tree().get_first_node_in_group("Player")
	_time_count()
	
func _time_count():
	await get_tree().create_timer(1,false).timeout
	if in_game:
		if seconds == 59:
			mins += 1
			seconds = 0
		else:
			seconds += 1
			
		if mins < 10 and seconds >= 10:
			PlayerData.player_time ="0"+str(mins)+":"+str(seconds)
			
		elif mins < 10 and seconds < 10:
			PlayerData.player_time = "0"+str(mins)+":0"+str(seconds)
			
		elif mins >= 10 and seconds >= 10:
			PlayerData.player_time = str(mins)+":"+str(seconds)
			
	_time_count()

func reset_game():
	difficulty = null
	class_selected = null
	character_created = null
	won_game = false
	game_started = false
	level_upgrades = [1,1,1,1,1]
	levels_completed = 0
	highest_level_completed = 0
	checkpoint = Vector2.ZERO
	mins = 0
	seconds = 0
	currency = 0
	must_climb = false
	player_time = ""
	relics = ["None","None","None","None"]
	relic_equipped = -1
	divinity = 1
	in_game = false
	username = null
	look = null
	

func _process(delta):
	player_ref = get_tree().get_first_node_in_group("Player")
	if not username and in_game:
		username = "Anonymous"
	if not class_selected and in_game:
		var rand_class = randi_range(0,3)
		match rand_class:
			0:
				class_selected = "Soul Siphon"
			1:
				class_selected = "Slayer"
			2:
				class_selected = "Juggernaut"
