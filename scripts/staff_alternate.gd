extends StaticBody2D


func _ready():
	await get_tree().create_timer(1,false).timeout
	self.modulate = Color(1,1,1,1)


func _process(delta):
	
	scale.x += 0.04
	scale.y += 0.04
	
	if scale.x > 2:
		queue_free()

func _physics_process(delta):
	move_and_collide(constant_linear_velocity* delta)

