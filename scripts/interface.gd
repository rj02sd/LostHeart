extends CanvasLayer

var interactable = false
var poisoned = false

var heart_boss_ready = false
var message_displayed = false

var mins = 0
var seconds = 0
		
func _process(delta):
	
	%Timer/time.text = PlayerData.player_time
	
	if PlayerData.username:
		%Username.text = PlayerData.username
	if PlayerData.class_selected:
		%Class.text = PlayerData.class_selected
		
	if poisoned:
		%PoisonHealth.visible = true
	else:
		%PoisonHealth.visible = false
		
	%Currency.text = str(PlayerData.currency) + " RUNES"
	if interactable:
		%Interact.visible = true
	else:
		%Interact.visible = false
	if get_tree().get_first_node_in_group("Player"):
		%Health.max_value = get_tree().get_first_node_in_group("Player").player_stats.max_health
		%Health.value = get_tree().get_first_node_in_group("Player").player_stats.health
		%PoisonHealth.max_value = get_tree().get_first_node_in_group("Player").player_stats.max_health
		%PoisonHealth.value = get_tree().get_first_node_in_group("Player").player_stats.health
		%Spirit.max_value = get_tree().get_first_node_in_group("Player").player_stats.max_spirit
		%Spirit.value = get_tree().get_first_node_in_group("Player").player_stats.spirit
	
	if PlayerData.player_ref:
		if heart_boss_ready and not PlayerData.player_ref.heart_felled:
			if get_tree().get_first_node_in_group("Heart"):
				%HeartHealth.visible = true
				%HeartHealth.max_value = get_tree().get_first_node_in_group("Heart").health_per_layer
				%HeartHealth.value = get_tree().get_first_node_in_group("Heart").curr_health
				%HeartHealth/LayersLeft.text = "x" + str(get_tree().get_first_node_in_group("Heart").max_layers - get_tree().get_first_node_in_group("Heart").layers_cured - 1)
		
		if PlayerData.player_ref.heart_felled and not message_displayed:
			message_displayed = true
			%HeartHealth.visible = false
			_temp_display()
			
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
	
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0,true)
			
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Menu"):
		%pause_menu.visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func _temp_display():
	%HeartFelled.visible = true
	await get_tree().create_timer(3,false).timeout
	%HeartFelled.visible = false


func _on_mute_pressed():
	AudioServer.set_bus_mute(0,true)


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_pause_pressed():
	get_tree().paused = true
	%Pause.visible = false
	%Play.visible = true
	

func _on_play_pressed():
	get_tree().paused = false
	%Pause.visible = true
	%Play.visible = false
	


func _on_menu_pressed():
	%pause_menu.visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
