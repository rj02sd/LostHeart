extends CanvasLayer

@export var levels:Array[PackedScene]

func _ready():
	pass

func _process(delta):
	pass


func _on_level_button_1_pressed():
	if levels[0]:
		get_tree().change_scene_to_packed(levels[0])


func _on_level_button_2_pressed():
	if levels[1]:
		get_tree().change_scene_to_packed(levels[1])


func _on_level_button_3_pressed():
	if levels[2]:
		get_tree().change_scene_to_packed(levels[2])


func _on_level_button_4_pressed():
	if levels[3]:
		get_tree().change_scene_to_packed(levels[3])


func _on_level_button_5_pressed():
	if levels[4]:
		get_tree().change_scene_to_packed(levels[4])
