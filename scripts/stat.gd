extends Label

@export var stat_name:String
@export var stat_index:int
@export var stat_color:Color

func _ready():
	text = stat_name
	for point in %Points.get_children():
		point.color = stat_color


func _process(delta):
	for point in range(%Points.get_children().size()):
		if point < PlayerData.level_upgrades[stat_index]:
			%Points.get_child(point).visible = true
		else:
			%Points.get_child(point).visible = false


func _on_add_pressed():
	if PlayerData.level_upgrades[stat_index] < 10:
		if PlayerData.currency > 500:
			PlayerData.currency -= 500
			PlayerData.level_upgrades[stat_index] += 1
			match stat_index:
				0:
					PlayerData.player_ref.player_stats.max_health += 10
					PlayerData.player_ref.player_stats.health += 10
				1:
					PlayerData.player_ref.player_stats.max_spirit += 10
					PlayerData.player_ref.player_stats.spirit += 10
					PlayerData.player_ref.player_stats.spirit_regen += 1
				2:
					PlayerData.player_ref.player_stats.resistance += 5
					if PlayerData.player_ref.player_stats.resistance >=85:
						PlayerData.player_ref.player_stats.resistance = 85
				3:
					PlayerData.player_ref.player_stats.speed += 20
				4:
					PlayerData.player_ref.player_stats.attack_damage_multiplier += 0.1


func _on_subtract_pressed():
	if PlayerData.level_upgrades[stat_index] > 1:
		PlayerData.currency += 500
		PlayerData.level_upgrades[stat_index] -= 1
