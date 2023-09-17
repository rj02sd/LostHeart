extends StaticBody2D

var big_bullet = preload("res://prefabs/projectiles/big_bullet.tscn")

@export var launch_rate = 3.0

func _ready():
	_launch()


func _process(delta):
	pass

func _launch():
	await get_tree().create_timer(launch_rate,false).timeout
	var bullet = big_bullet.instantiate()
	bullet.global_position = %Launch.global_position
	get_parent().add_child(bullet)
	_launch()

