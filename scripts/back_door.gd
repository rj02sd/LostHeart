extends StaticBody2D


func _ready():
	pass


func _process(delta):
	if PlayerData.player_ref.heart_felled:
		visible = false
		get_child(0).disabled = true
