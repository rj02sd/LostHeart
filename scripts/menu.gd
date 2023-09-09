extends CanvasLayer

var next_scene = preload("res://scenes/difficulty_selection.tscn")

func _ready():
	pass


func _process(delta):
	pass


func _on_play_pressed():
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)


func _on_controls_pressed():
	%controls.visible = true


func _on_credits_pressed():
	%credits.visible = true


func _on_tutorial_pressed():
	%tutorial.visible = true
