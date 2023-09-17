extends CanvasLayer



func _ready():
	pass



func _process(delta):
	pass


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_level_select_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_resume_level_pressed():
	get_tree().paused = false
	visible = false
