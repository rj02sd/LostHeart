extends CanvasLayer

var next_scene = preload("res://scenes/character_creator.tscn")

func _ready():
	pass

func _process(delta):
	pass


func _on_easy_pressed():
	PlayerData.difficulty = "Easy"
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)


func _on_hard_pressed():
	PlayerData.difficulty = "Hard"
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
