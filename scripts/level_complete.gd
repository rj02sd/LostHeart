extends CanvasLayer

var next_lvl

func _ready():
	next_lvl = get_parent().level_index+2


func _process(delta):
	pass


func _on_next_level_pressed():
	if next_lvl < 6:
		get_tree().change_scene_to_file("res://levels/level"+str(next_lvl)+".tscn")
	else:
		PlayerData.won_game = true
		get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
