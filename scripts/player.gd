extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 100.0
const JUMP_VELOCITY = -650.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass
	
func _process(delta):
	if not PlayerData.in_game:
		PlayerData.in_game = true
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		pass
		var normal = get_floor_normal()
		$PlayerSprite.rotation = normal.angle() + deg_to_rad(90)
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and not PlayerData.must_climb:
		velocity.y = JUMP_VELOCITY
	
	var directionx = Input.get_axis("move_left", "move_right")
	var directiony = Input.get_axis("climb_up", "climb_down")
	
	if directionx:
		velocity.x = directionx * SPEED
		if directionx < 0:
			%PlayerSprite.flip_h = true
		elif directionx >= 0:
			%PlayerSprite.flip_h = false
		%PlayerSprite.play("moving")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		%PlayerSprite.play("idle")
	
	if directiony and PlayerData.must_climb:
		velocity.y = directiony * CLIMB_SPEED * 2
	elif PlayerData.must_climb:
		velocity.y = CLIMB_SPEED
		

	move_and_slide()
