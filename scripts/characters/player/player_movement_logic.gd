extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_1_timer = $AttackLogicContainer/Attack1_Timer
@onready var attack_2_timer = $AttackLogicContainer/Attack2_Timer

const MOVE_SPEED = 200.0
const JUMP_FORCE = -250
const JUMP_TIME = 0.3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_timer = JUMP_TIME

func _physics_process(delta):
	
	if attack_1_timer.is_stopped() && attack_2_timer.is_stopped(): 
		check_movement(delta)
	else:
		velocity.x = 0
		
	move_and_slide()

func check_movement(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * MOVE_SPEED
		animated_sprite.flip_h = direction == -1
	else:
		velocity.x = lerp(velocity.x, 0.0, 1)
		
	if !is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_pressed("jump") && jump_timer > 0:
			velocity.y = JUMP_FORCE
			jump_timer -= delta
			
		if velocity.y < 0:
			if Input.is_action_just_released("jump") || jump_timer <= 0:
				velocity.y = 0
	else:
		jump_timer = JUMP_TIME
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_FORCE
