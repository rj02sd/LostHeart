extends RigidBody2D


func _ready():
	await get_tree().create_timer(0.1,false).timeout
	linear_velocity.x *= 15
	await get_tree().create_timer(3,false).timeout
	queue_free()


func _process(delta):
	pass

func _physics_process(delta):
	move_and_collide(linear_velocity*delta)
