extends StaticBody2D

var num_vines = 0
var max_layers = 3
var layers_cured = 0
var health_per_layer = 50
var curr_health = 50

var down = true
var moving = false

func _ready():
	pass
	
func _process(delta):

	num_vines = 0
	for x in get_tree().get_nodes_in_group("Vine"):
		if x.visible:
			num_vines += 1
		
	if num_vines == 0 and layers_cured < max_layers and curr_health <= 0:
		curr_health = health_per_layer
		layers_cured += 1
		moving = false
		position.y -= 200
		for x in get_tree().get_nodes_in_group("Vine"):
			x.visible = true
	
	elif num_vines == 0 and not moving:
		position.y += 200
		moving = true
	
	elif layers_cured >= max_layers:
		%PointLight2D.color = Color(1,1,1,1)
		%PointLight2D.energy = 10
		PlayerData.player_ref.heart_felled = true
		PlayerData.currency += 100000000
		
