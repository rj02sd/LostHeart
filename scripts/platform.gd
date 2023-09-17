extends StaticBody2D

@export var type = 0
@export var platform_direction = Vector2(0,100)
@export var speed_plat = 1.0
@export var spike_cooldown = 4

var to_dest = true
var speed
var prev_loc = position.y
var velocitY
var player_ref

var correct_vel = false

func _ready():
	if type == 1:
		constant_linear_velocity = platform_direction
		_oscillate_platform()
	if type == 2:
		get_child(0).one_way_collision = false
		_activate_spikes()
	if type == 3:
		%Illusion.visible = true
		%Illusion.get_child(0).disabled = false

func _process(delta):
	if type == 1:
		speed = speed_plat * constant_linear_velocity * delta
		velocitY = (position.y - prev_loc / delta)
		prev_loc = position.y
		
		if to_dest:
			if platform_direction.y < 0:
				%PlayerSmoothing/Top.disabled = true
				%PlayerSmoothing.visible = false
			else:
				%PlayerSmoothing/Top.disabled = false
				%PlayerSmoothing.visible = true
			position += speed
		elif not to_dest:
			if platform_direction.y < 0:
				%PlayerSmoothing/Top.disabled = false
				%PlayerSmoothing.visible = true
			else:
				%PlayerSmoothing/Top.disabled = true
				%PlayerSmoothing.visible = false
			position -= speed
		
		if correct_vel and not platform_direction.y == 0:
			if player_ref.on_platform:
				if to_dest:
					player_ref.velocity.y = velocitY/1000
				elif not to_dest:
					player_ref.velocity.y = velocitY/1000

func _oscillate_platform():
	await get_tree().create_timer(ceil(5/speed_plat),false).timeout
	if to_dest:
		to_dest = false
	else:
		to_dest = true
	_oscillate_platform()
	
func _activate_spikes():
	await get_tree().create_timer(spike_cooldown,false).timeout
	%Spikes.visible = true
	%Spikes/Spike.visible = false
	%Spikes/Warning.visible = true
	await get_tree().create_timer(1,false).timeout
	%spikesAudio.play()
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
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Enemy":
		if type == 2:
			body.health = 0

func _on_player_smoothing_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 1:
			body.on_platform = true
			%PlayerSmoothing/SideL.disabled = false
			%PlayerSmoothing/SideR.disabled = false
			player_ref = body
			correct_vel = true


func _on_player_smoothing_body_exited(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 1:
			%PlayerSmoothing/SideL.disabled = true
			%PlayerSmoothing/SideR.disabled = true
			body.on_platform = false
			player_ref = null
			correct_vel = false
