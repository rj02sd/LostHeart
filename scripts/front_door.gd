extends StaticBody2D

var locked_in = false

func _ready():
	pass


func _process(delta):
		
	if (PlayerData.player_ref.martyr_killed and not locked_in) or PlayerData.player_ref.heart_felled:
		visible = false
		get_child(0).disabled = true
	if locked_in and not PlayerData.player_ref.heart_felled:
		visible = true
		get_child(0).disabled = false		


func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		locked_in = true
		if get_tree().get_first_node_in_group("Interface"):
			get_tree().get_first_node_in_group("Interface").heart_boss_ready = true
