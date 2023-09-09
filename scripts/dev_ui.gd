extends CanvasLayer

@export var level_num:int
var win_scene = preload("res://scenes/level_complete.tscn")
var loss_scene = preload("res://scenes/death_screen.tscn")

func _ready():
	%leveltxt.text = "LEVEL "+str(level_num)


func _process(delta):
	pass


func _on_win_pressed():
	%level_complete.visible = true
	PlayerData.in_game = false


func _on_lose_pressed():
	%death_screen.visible = true
	PlayerData.in_game = false
