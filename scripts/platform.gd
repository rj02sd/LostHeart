extends StaticBody2D

@export var type = 0
@export var platform_direction = Vector2(0,100)

var to_dest = true

func _ready():
	if type == 1:
		get_child(0).one_way_collision = false
		constant_linear_velocity = platform_direction
		_oscillate_platform()
	if type == 2:
		_activate_spikes()
	if type == 3:
		%Illusion.visible = true
		%Illusion.get_child(0).disabled = false

func _process(delta):
	if type == 1:
		if to_dest:
			position += constant_linear_velocity * delta
		elif not to_dest:
			position -= constant_linear_velocity * delta
		

func _oscillate_platform():
	await get_tree().create_timer(5,false).timeout
	if to_dest:
		to_dest = false
	else:
		to_dest = true
	_oscillate_platform()
	
func _activate_spikes():
	await get_tree().create_timer(2,false).timeout
	%Spikes.visible = true
	%Spikes/Spike.visible = false
	%Spikes/Warning.visible = true
	await get_tree().create_timer(3,false).timeout
	%Spikes/Spike.visible = true
	%Spikes/Warning.visible = false
	%Spikes.get_child(0).disabled = false
	await get_tree().create_timer(3,false).timeout
	%Spikes.visible = false
	%Spikes.get_child(0).disabled = true
	_activate_spikes()
	
func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 3:
			visible = false


func _on_area_2d_body_exited(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 3:
			visible = true


func _on_spikes_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 2:
			body.player_stats.health -= 50
