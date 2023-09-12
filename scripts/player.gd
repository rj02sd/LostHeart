extends CharacterBody2D

@export var player_stats = {
	max_health = 100,
	max_spirit = 100,
	health = 100,
	spirit = 100,
	speed = 300,
	speed_multiplier = 1,
	climb_speed = 100,
	jump_velocity = -650,
	num_jumps = 1,
	attack_damage_multiplier = 1,
	resistance = 75,
	critical_chance = 0,
	critical_damage_multiplier = 1,
	currency_multiplier = 1,
	vamp = 0,
	divinity = 1,
	attack_speed_multiplier = 1
}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var alternate = preload("res://prefabs/projectiles/staff_alternate.tscn")

var alternate_ready = true
var interact_index = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _process(delta):
	if not PlayerData.in_game:
		PlayerData.in_game = true
	if Input.is_action_just_pressed("primary_attack"):
		if %PlayerSprite.flip_h:
			%StaffHitboxLeft.disabled = false
			await get_tree().create_timer(1,false).timeout
			%StaffHitboxLeft.disabled = true
		else:
			%StaffHitboxRight.disabled = false
			await get_tree().create_timer(1,false).timeout
			%StaffHitboxRight.disabled = true
	if Input.is_action_just_pressed("alternate_attack") and alternate_ready:
		var alt = alternate.instantiate()
		alt.position = position
		get_parent().add_child(alt)
		_cooldown_alternate(2)
	if Input.is_action_just_pressed("interact"):
		match interact_index:
			0:
				pass
			1:
				pass
			2:
				pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		pass
		var normal = get_floor_normal()
		$PlayerSprite.rotation = normal.angle() + deg_to_rad(90)
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and not PlayerData.must_climb:
		velocity.y = player_stats.jump_velocity
	
	var directionx = Input.get_axis("move_left", "move_right")
	var directiony = Input.get_axis("climb_up", "climb_down")
	
	if directionx:
		velocity.x = directionx * player_stats.speed * player_stats.speed_multiplier
		if directionx < 0:
			%PlayerSprite.flip_h = true
		elif directionx >= 0:
			%PlayerSprite.flip_h = false
		%PlayerSprite.play("moving")
	else:
		velocity.x = move_toward(velocity.x, 0, player_stats.speed * player_stats.speed_multiplier)
		%PlayerSprite.play("idle")
	
	if directiony and PlayerData.must_climb:
		velocity.y = directiony * player_stats.climb_speed * 2
		floor_max_angle = 85
	elif PlayerData.must_climb:
		velocity.y = player_stats.climb_speed
		floor_max_angle = 0
	elif not PlayerData.must_climb:
		floor_max_angle = 0
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Enemy":
		body.health -= 5

func _cooldown_alternate(time):
	alternate_ready = false
	await get_tree().create_timer(time,false).timeout
	alternate_ready = true


func _on_area_2d_2_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Bullet":
		body.queue_free()
		player_stats.health -= 10
