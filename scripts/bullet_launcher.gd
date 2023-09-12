extends StaticBody2D

var big_bullet = preload("res://prefabs/projectiles/big_bullet.tscn")

func _ready():
	_launch()


func _process(delta):
	pass

func _launch():
	await get_tree().create_timer(3,false).timeout
	var bullet = big_bullet.instantiate()
	bullet.global_position = %Launch.global_position
	get_parent().add_child(bullet)
	_launch()

