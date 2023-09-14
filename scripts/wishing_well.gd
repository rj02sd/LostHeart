extends CanvasLayer


func _ready():
	pass


func _process(delta):
	%Currency.text = str(PlayerData.currency) + " RUNES"


func _on_return_pressed():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
