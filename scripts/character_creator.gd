extends CanvasLayer

var next_scene = preload("res://scenes/level_select.tscn")

func _ready():
	pass

func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_create_pressed():
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)


func _on_class_1_pressed():
	PlayerData.class_selected = "Soul Siphon"


func _on_class_2_pressed():
	PlayerData.class_selected = "Slayer"


func _on_class_3_pressed():
	PlayerData.class_selected = "Juggernaut"


func _on_username_text_changed():
	PlayerData.username = %Username.text
