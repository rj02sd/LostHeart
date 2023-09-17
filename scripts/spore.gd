extends RigidBody2D

var target
var speed = 150

func _ready():
	await get_tree().create_timer(4,false).timeout
	queue_free()


func _process(delta):
	pass

func _physics_process(delta):
	if target:
		move_and_collide(position.direction_to(target.position)*delta*speed)
