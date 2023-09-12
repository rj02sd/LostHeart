extends CanvasLayer

var interactable = false

func _ready():
	pass


func _process(delta):
	%Currency.text = str(PlayerData.currency) + " RUNES"
	if interactable:
		%Interact.visible = true
	else:
		%Interact.visible = false
	if get_tree().get_first_node_in_group("Player"):
		%Health.max_value = get_tree().get_first_node_in_group("Player").player_stats.max_health
		%Health.value = get_tree().get_first_node_in_group("Player").player_stats.health
		%Spirit.max_value = get_tree().get_first_node_in_group("Player").player_stats.max_spirit
		%Spirit.value = get_tree().get_first_node_in_group("Player").player_stats.spirit
