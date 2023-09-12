extends StaticBody2D

func _ready():
	await get_tree().create_timer(10,false).timeout
	queue_free()


func _physics_process(delta):
	move_and_collide(constant_linear_velocity* delta)
