extends CanvasLayer

var next_scene = preload("res://scenes/level_select.tscn")

func _ready():
	pass

func _process(delta):
	pass


func _on_next_pressed():
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
