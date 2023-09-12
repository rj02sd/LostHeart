extends RigidBody2D

var max_health = 20
var health = 20
var speed = 100
var target

func _ready():
	%health.max_value = max_health

func _process(delta):
	%health.value = health
	if health <= 0:
		%sprite.modulate = Color(1,1,1,0.5)
		%CollisionShape2D.disabled = true
		gravity_scale = -0.1
		%health.visible = false
		%Area2D.get_child(0).disabled = true
		%Area2D.get_child(1).disabled = true
	if abs(rotation) > 0.5:
		await get_tree().create_timer(3,false).timeout
		if abs(rotation) > 0.5:
			rotation = 0
	
func _physics_process(delta):
	if target:
		var velocity = position.direction_to(target.position)
		move_and_collide(velocity * speed * delta)

func _on_area_2d_body_entered(body):
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Player":
		target = body
	if body.get_groups().size() > 0 and body.get_groups()[0] == "Alternate":
		health -= 3
