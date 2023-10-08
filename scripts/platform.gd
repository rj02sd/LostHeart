extends StaticBody2D

@export var type = 0
@export var platform_direction = Vector2(0,100)
@export var speed_plat = 4
@export var spike_cooldown = 4
@export var illusion_time = 2

var to_dest = true
var speed
var prev_loc = position.y
var velocitY
var player_ref
var illusion_active
var illusion_tween
var on_platform = false

var correct_vel = false

func _ready():
	illusion_tween = create_tween()
	if type == 1:
		_oscillate_platform()
	if type == 2:
		get_child(0).one_way_collision = false
		_activate_spikes()
	if type == 3:
		%Illusion.visible = true
		%Illusion.get_child(0).disabled = false
	
func _oscillate_platform():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self,"position",global_position+platform_direction,4)
	tween.chain().tween_property(self,"position",global_position,4)
	
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

func illusion_changer():
	if illusion_active or not on_platform:
		illusion_active = false
		get_child(0).disabled = false
	elif on_platform:
		illusion_active = true
		get_child(0).disabled = true
		
func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 3:
			illusion_tween.stop()
			illusion_tween = create_tween()
			illusion_tween.set_ease(illusion_tween.EASE_IN)
			illusion_tween.tween_property(self,"modulate",Color(1,1,1,0),illusion_time)
			illusion_tween.connect("finished",illusion_changer)
			on_platform = true


func _on_area_2d_body_exited(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 3:
			illusion_tween.stop()
			illusion_tween = create_tween()
			illusion_tween.set_ease(illusion_tween.EASE_OUT)
			illusion_tween.tween_property(self,"modulate",Color(1,1,1,1),0.1)
			illusion_tween.connect("finished",illusion_changer)
			on_platform = false


func _on_spikes_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		if type == 2:
			body.player_stats.health -= 50
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Enemy":
		if type == 2:
			body.health = 0
