extends RigidBody2D

var max_health = 20
var health = 20
var speed = 100
var currency_gain = 100
var shadow = true
var target

func _ready():
	%health.max_value = max_health
	_attack()

func _process(delta):
	%health.value = health
	if health <= 0 and shadow:
		shadow = false
		%sprite.modulate = Color(1,1,1,0.5)
		%CollisionShape2D.disabled = true
		gravity_scale = -0.1
		%health.visible = false
		%Area2D.get_child(0).disabled = true
		%Area2D.get_child(1).disabled = true
		%SwordL.visible = false
		%SwordR.visible = false
		%SwordR/SwordR/RSw.disabled = true
		%SwordL/SwordL/LSw.disabled = true
		PlayerData.currency += currency_gain
		target = null
	if abs(rotation) > 0.5:
		await get_tree().create_timer(3,false).timeout
		if abs(rotation) > 0.5:
			rotation = 0

func _attack():
	if target and shadow and health > 0:
		%WarningL.visible = true
		%WarningR.visible = true
		await get_tree().create_timer(0.5,false).timeout
		if health > 0:
			%SwordL.visible = true
			%SwordR.visible = true
			%SwordR/SwordR/RSw.disabled = false
			%SwordL/SwordL/LSw.disabled = false
			%WarningL.visible = false
			%WarningR.visible = false
		else:
			%WarningL.visible = false
			%WarningR.visible = false
		await get_tree().create_timer(1.5,false).timeout
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
	if target:
		var velocity = position.direction_to(target.position)
		move_and_collide(velocity * speed * delta)

func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		target = body
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Alternate":
		health -= 2


func _on_sword_r_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		body.player_stats.health -= 10

func _on_sword_l_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		body.player_stats.health -= 10
