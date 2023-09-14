extends Area2D

var spore = preload("res://prefabs/projectiles/spore.tscn")
var target
var health = 10
var cured = false

func _ready():
	%Health.max_value = health
	_launch_spores()
	

func _process(delta):
	%Health.value = health
	if health <= 0 and not cured:
		%Health.visible = false
		%Sprite.modulate = Color(1,1,1,1)
		PlayerData.currency += 75
		cured = true

func _launch_spores():
	if target and not cured:
		await get_tree().create_timer(1,false).timeout
		for i in range(3):
			var curr_spore = spore.instantiate()
			match i:
				1:
					curr_spore.global_position = %L1.global_position
				2:
					curr_spore.global_position = %L2.global_position
				3:
					curr_spore.global_position = %L3.global_position
			curr_spore.target = target
			get_parent().add_child(curr_spore)
		await get_tree().create_timer(5,false).timeout
		_launch_spores()
	elif not cured:
		await get_tree().create_timer(0.1,false).timeout
		_launch_spores()
		
func _on_range_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		target = body
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Alternate":
		health -= 2
