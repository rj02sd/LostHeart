extends Area2D

var spore = preload("res://prefabs/projectiles/spore.tscn")
var target

@export var health = 10
@export var currency = 75
@export var projectiles = 3
@export var charge = 1
@export var fire_rate = 5
@export var resistance = 0

var cured = false

func _ready():
	%Health.max_value = health
	_launch_spores()
	

func _process(delta):
	%Health.value = health
	if health <= 0 and not cured:
		%Health.visible = false
		%PointLight2D.color = Color(1,1,1,1)
		%PointLight2D.energy = 10
		%Sprite.modulate = Color(1,1,1,1)
		PlayerData.currency += currency * PlayerData.player_ref.player_stats.currency_multiplier
		cured = true
		_fade_away(0)

func _fade_away(iter):
	if iter > 10:
		queue_free()
	await get_tree().create_timer(0.5).timeout
	%Sprite.modulate = Color(1,1,1,1-0.05*iter)
	_fade_away(iter+1)
	
func _launch_spores():
	if target and not cured:
		await get_tree().create_timer(charge,false).timeout
		for i in range(projectiles):
			var curr_spore = spore.instantiate()
			match i%3:
				0:
					curr_spore.global_position = %L1.global_position
				1:
					curr_spore.global_position = %L2.global_position
				2:
					curr_spore.global_position = %L3.global_position
			curr_spore.target = target
			get_parent().add_child(curr_spore)
		await get_tree().create_timer(fire_rate,false).timeout
		_launch_spores()
	elif not cured:
		await get_tree().create_timer(0.1,false).timeout
		_launch_spores()
		
func _on_range_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		target = body
