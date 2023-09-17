extends CharacterBody2D

@export var player_stats = {
	max_health = 100,
	max_spirit = 100,
	health = 100,
	spirit = 100,
	spirit_regen = 20,
	speed = 300,
	jump_velocity = -650,
	climb_speed = 100,
	attack_damage_multiplier = 1,
	resistance = 10,
	critical_chance = 0,
	critical_damage_multiplier = 1,
	currency_multiplier = 1,
	vamp = 0,
	attack_speed_multiplier = 1
}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var alternate = preload("res://prefabs/projectiles/staff_alternate.tscn")

var scared = false
var alternate_ready = true
var won = false
var in_combat = false
var jumping = false
var only_moving = false
var staff_slammed = false
var poison = false
var bullet_currency = 50
var on_platform = false
var martyr_killed = false
var heart_felled = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	match PlayerData.class_selected:
		"Soul Siphon":
			player_stats.vamp += (PlayerData.levels_completed+1) * 10
			player_stats.currency_multiplier += (PlayerData.levels_completed+1) * 1.5
			player_stats.max_health -= 30
			player_stats.health -= 30
		"Slayer":
			player_stats.critical_chance += (PlayerData.levels_completed+1) * 10
			player_stats.attack_damage_multiplier += (PlayerData.levels_completed+1) * 5
			player_stats.critical_damage_multiplier += (PlayerData.levels_completed+1) * 10
			player_stats.max_spirit -= 40
			player_stats.spirit -= 40
			player_stats.spirit_regen -= 5
		"Juggernaut":
			player_stats.resistance += (PlayerData.levels_completed+1) * 10
			player_stats.health += (PlayerData.levels_completed+1) * 20
			player_stats.max_health += (PlayerData.levels_completed+1) * 20
			player_stats.attack_speed_multiplier -= 0.4
			player_stats.climb_speed -= 20
	
func _process(delta):
	if player_stats.health <=0 and not won:
		%death_screen.visible = true
		PlayerData.in_game = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if poison and get_tree().get_first_node_in_group("Interface"):
		get_tree().get_first_node_in_group("Interface").poisoned = true
	elif get_tree().get_first_node_in_group("Interface"):
		get_tree().get_first_node_in_group("Interface").poisoned = false
	
	if player_stats.spirit <= 0:
		player_stats.spirit = 0
		
	if not PlayerData.in_game:
		PlayerData.in_game = true
		
	if player_stats.spirit < player_stats.max_spirit:
		player_stats.spirit += player_stats.spirit_regen*delta
		
	if Input.is_action_just_pressed("primary_attack") and not PlayerData.must_climb and not in_combat and player_stats.spirit > 11 and not staff_slammed:
		if only_moving and not jumping:
			%HandsSprite.play("slash_half")
		else:
			%PlayerSprite.play("slash")
		player_stats.spirit -= 20
		_cooldown_primary(0.5/player_stats.attack_speed_multiplier)
			
	if Input.is_action_just_pressed("alternate_attack") and not PlayerData.must_climb and not in_combat and alternate_ready and player_stats.spirit > 33:
		player_stats.spirit -= 10+player_stats.spirit/3
		var alt = alternate.instantiate()
		alt.position = position
		get_parent().add_child(alt)
		velocity = Vector2.ZERO
		%HandsSprite.visible = false
		%PlayerSprite.play("staff_slam")
		_cooldown_alternate(0.6/player_stats.attack_speed_multiplier)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		var normal = get_floor_normal()
		if not PlayerData.must_climb:
			$PlayerSprite.rotation = normal.angle() + deg_to_rad(90)
		else:
			$PlayerSprite.rotation = normal.angle() + deg_to_rad(180)
	
	var directionx = Input.get_axis("move_left", "move_right")
	var directiony = Input.get_axis("climb_up", "climb_down")
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not PlayerData.must_climb:
		if not scared:
			if directionx == 0:
				velocity.y = player_stats.jump_velocity - 50
			else:
				velocity.y = player_stats.jump_velocity
			%HandsSprite.visible = false
			_jump_time(1)
	
	if PlayerData.must_climb:
		%PlayerSprite.flip_h = false
			
	if directionx and not staff_slammed:
		velocity.x = directionx * player_stats.speed
		if PlayerData.must_climb:
			%PlayerSprite.flip_h = false
		elif directionx < 0:
			%PlayerSprite.flip_h = true
			%HandsSprite.flip_h = true
		elif directionx >= 0:
			%PlayerSprite.flip_h = false
			%HandsSprite.flip_h = false
		if PlayerData.must_climb:
			%PlayerSprite.play("climbing")
			%HandsSprite.visible = false
			only_moving = false
		elif not jumping:
			%PlayerSprite.play("moving_half")
			%HandsSprite.visible = true
			if not in_combat:
				%HandsSprite.play("unarmed_half")
			only_moving = true
	elif not staff_slammed:
		velocity.x = move_toward(velocity.x, 0, player_stats.speed)
		if PlayerData.must_climb:
			%PlayerSprite.play("climbing")
			%HandsSprite.visible = false
			only_moving = false
		elif not jumping and not directiony and not in_combat:
			%PlayerSprite.play("idle")
			%HandsSprite.visible = false
			only_moving = false
	
	if directiony and PlayerData.must_climb:
		velocity.y = directiony * player_stats.climb_speed * 2
		floor_max_angle = 85
		%PlayerSprite.play("climbing")
	elif PlayerData.must_climb:
		velocity.y = player_stats.climb_speed
		floor_max_angle = 0
	elif not PlayerData.must_climb:
		floor_max_angle = 0
	
	move_and_slide()

func _calculate_attack_strength(base,resist):
	if randi_range(0,100) < player_stats.critical_chance:
		base = base * (1+player_stats.critical_damage/100)**1.5
	resist = round(1-resist/100)
	base = base * resist * player_stats.attack_damage_multiplier
	return base
		
func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Enemy":
		body.health -= _calculate_attack_strength(5,body.resistance)
		player_stats.health += _calculate_attack_strength(5,body.resistance) * (player_stats.vamp/100)
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Bullet":
		PlayerData.currency += bullet_currency * PlayerData.player_ref.player_stats.currency_multiplier
		body.queue_free()
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Heart":
		if body.num_vines == 0:
			body.curr_health -= _calculate_attack_strength(5,0)

		
func _jump_time(time):
	jumping = true
	on_platform = false
	%PlayerSprite.play("jumping")
	await get_tree().create_timer(time,false).timeout
	%PlayerSprite.play("idle")
	jumping = false

func _poisoned(dmg,ticks_left):
	if ticks_left != 0:
		poison = true
		await get_tree().create_timer(1,false).timeout
		player_stats.health -= dmg
		_poisoned(dmg,ticks_left-1)
	else:
		poison = false
		
func _cooldown_primary(time):
	in_combat = true
	if %PlayerSprite.flip_h:
		%StaffHitboxLeft.disabled = false
		await get_tree().create_timer(time,false).timeout
		%StaffHitboxLeft.disabled = true
	else:
		%StaffHitboxRight.disabled = false
		await get_tree().create_timer(time,false).timeout
		%StaffHitboxRight.disabled = true
	in_combat = false
	
func _cooldown_alternate(time):
	in_combat = true
	alternate_ready = false
	staff_slammed = true
	gravity *= 5
	await get_tree().create_timer(time,false).timeout
	gravity /= 5
	staff_slammed = false
	in_combat = false
	%PlayerSprite.play("idle")
	alternate_ready = true

func _on_area_2d_2_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Bullet":
		body.queue_free()
		player_stats.health -= 10 * (1-(player_stats.resistance/100))
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Spore":
		if not poison:
			_poisoned(1,5)
		else:
			player_stats.health -= 1
		body.queue_free()
	
func _on_area_2d_area_entered(area):
	if area.get_groups().size() > 0 and area.get_groups()[0] == "Plant_Hitbox":
		area.get_parent().health -= _calculate_attack_strength(5,area.get_parent().resistance)
		player_stats.health +=  _calculate_attack_strength(5,area.get_parent().resistance) * (player_stats.vamp/100)
	if area.get_groups().size() > 0 and area.get_groups()[0] == "Vine":
		area.visible = false
