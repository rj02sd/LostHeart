extends ParallaxLayer

@export var cloud_speed = -10

func _ready():
	pass


func _process(delta):
	motion_offset.x = cloud_speed * delta
