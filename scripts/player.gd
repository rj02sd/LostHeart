extends CharacterBody2D

@export var player_stats = {
	max_health = 100,
	max_spirit = 100,
	health = 100,
	spirit = 100,
	spirit_regen = 20,
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

var scared = false
var alternate_ready = true
var won = false
var in_combat = false
var jumping = false
var only_moving = false
var staff_slammed = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _process(delta):
	if player_stats.health <=0 and not won:
		%death_screen.visible = true
		PlayerData.in_game = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if player_stats.spirit <= 0:
		player_stats.spirit = 0
		
	if not PlayerData.in_game:
		PlayerData.in_game = true
		
	if player_stats.spirit < player_stats.max_spirit:
		player_stats.spirit += player_stats.spirit_regen*delta
		
	if Input.is_action_just_pressed("primary_attack") and not in_combat and player_stats.spirit > 11 and not staff_slammed:
		if only_moving and not jumping:
			%HandsSprite.play("slash_half")
		else:
			%PlayerSprite.play("slash")
		player_stats.spirit -= 20
		_cooldown_primary(0.5)
			
	if Input.is_action_just_pressed("alternate_attack") and not in_combat and alternate_ready and player_stats.spirit > 33:
		player_stats.spirit -= 10+player_stats.spirit/3
		var alt = alternate.instantiate()
		alt.position = position
		get_parent().add_child(alt)
		velocity = Vector2.ZERO
		%HandsSprite.visible = false
		%PlayerSprite.play("staff_slam")
		_cooldown_alternate(0.4)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		var normal = get_floor_normal()
		if not PlayerData.must_climb:
			$PlayerSprite.rotation = normal.angle() + deg_to_rad(90)
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and not PlayerData.must_climb:
		if not scared:
			velocity.y = player_stats.jump_velocity
			%HandsSprite.visible = false
			_jump_time(1)
	
	
	var directionx = Input.get_axis("move_left", "move_right")
	var directiony = Input.get_axis("climb_up", "climb_down")
	
	if directionx and not staff_slammed:
		velocity.x = directionx * player_stats.speed * player_stats.speed_multiplier
		if directionx < 0:
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
		velocity.x = move_toward(velocity.x, 0, player_stats.speed * player_stats.speed_multiplier)
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


func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Enemy":
		body.health -= 5

func _jump_time(time):
	jumping = true
	%PlayerSprite.play("jumping")
	await get_tree().create_timer(time,false).timeout
	%PlayerSprite.play("idle")
	jumping = false

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
	await get_tree().create_timer(time,false).timeout
	staff_slammed = false
	in_combat = false
	%PlayerSprite.play("idle")
	alternate_ready = true

func _on_area_2d_2_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Bullet":
		body.queue_free()
		player_stats.health -= 10
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Spore":
		player_stats.health -= 1
		body.queue_free()


func _on_area_2d_area_entered(area):
	if area.get_groups().size() > 0 and area.get_groups()[0] == "Plant_Hitbox":
		area.get_parent().health -= 5
