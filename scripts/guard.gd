extends CharacterBody2D

@export var tracking = false
@export var resistance = 0
@export var max_health = 20
@export var speed = 100
@export var currency_gain = 100

var health
var shadow = true
var target
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	health = max_health
	%health.max_value = max_health
	%health.value = 0
	if tracking:
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	_attack()

func _process(delta):
	%health.value = health
	if health <= 0 and shadow:
		shadow = false
		if get_groups().size() > 1:
			PlayerData.player_ref.martyr_killed = true
		%Overall_Light.energy = 5
		%Overall_Light.color = Color(1,1,1,1)
		%sprite.modulate = Color(1,1,1,1)
		%CollisionShape2D.disabled = true
		%health.visible = false
		%Area2D.get_child(0).disabled = true
		%Area2D.get_child(1).disabled = true
		%SwordL.visible = false
		%SwordR.visible = false
		%SwordR/SwordR/RSw.disabled = true
		%SwordL/SwordL/LSw.disabled = true
		PlayerData.currency += currency_gain * PlayerData.player_ref.player_stats.currency_multiplier
		target = null
		_dispose()
	if abs(rotation) > 0.5:
		await get_tree().create_timer(3,false).timeout
		if abs(rotation) > 0.5:
			rotation = 0

func _dispose():
	await get_tree().create_timer(5,false).timeout
	queue_free()
	
func _attack():
	if target and shadow and health > 0:
		%WarningL.visible = true
		%WarningR.visible = true
		await get_tree().create_timer(1.2,false).timeout
		if health > 0:
			%sword_sound.play()
			%SwordL.visible = true
			%SwordR.visible = true
			%SwordR/SwordR/RSw.disabled = false
			%SwordL/SwordL/LSw.disabled = false
			%WarningL.visible = false
			%WarningR.visible = false
		else:
			%WarningL.visible = false
			%WarningR.visible = false
		await get_tree().create_timer(0.6,false).timeout
		%SwordL.visible = false
		%SwordR.visible = false
		%SwordR/SwordR/RSw.disabled = true
		%SwordL/SwordL/LSw.disabled = true
		await get_tree().create_timer(3,false).timeout
		_attack()
	elif shadow:
		await get_tree().create_timer(0.1,false).timeout
		_attack()
		
func _physics_process(delta):
	if health <= 0:
		velocity.y -= gravity * delta
		move_and_slide()
	else:
		if not tracking:
			velocity.y += gravity * delta
			move_and_slide()
	if target:
		var velocity = position.direction_to(target.position)
		if tracking:
			move_and_collide(speed * velocity * delta)
		else:
			if velocity.x > 0:
				move_and_collide(Vector2(speed,0) * delta)
			else:
				move_and_collide(Vector2(-speed,0) * delta)

func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		target = body


func _on_sword_r_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		body.player_stats.health -= 10 * (1-(body.player_stats.resistance/100))

func _on_sword_l_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		body.player_stats.health -= 10 * (1-(body.player_stats.resistance/100))
