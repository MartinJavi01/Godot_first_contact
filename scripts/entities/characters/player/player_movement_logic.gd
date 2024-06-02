extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_1_shape = $AttackLogicContainer/Attack1_Hitbox/Attack_1_Shape
@onready var health_system = $HealthSystem

const MOVE_SPEED = 200.0
const JUMP_FORCE = -250
const JUMP_TIME = 0.3
const DASH_TIME = 0.3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_timer = JUMP_TIME
var input_blocked = false

var dashing = false
var can_dash = true

var direction = 1
var previous_direction = 1

func _physics_process(delta):
	velocity.y += gravity * delta
	if health_system.currentHealth > 0:
		if !input_blocked: 
			check_movement(delta) 
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			if dashing:
				velocity = Vector2(direction * MOVE_SPEED * 2, 0.0)
			
		move_and_slide()

func check_movement(delta):
	direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * MOVE_SPEED
		if direction != previous_direction:
			scale.x = -1
		previous_direction = direction
	else:
		velocity.x = lerp(velocity.x, 0.0, 1)
		
	if !is_on_floor():
		if Input.is_action_pressed("jump") && jump_timer > 0:
			velocity.y = JUMP_FORCE
			jump_timer -= delta
			
		if velocity.y < 0:
			if Input.is_action_just_released("jump") || jump_timer <= 0:
				jump_timer = 0
				velocity.y = 0
	else:
		can_dash = true
		jump_timer = JUMP_TIME
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_FORCE

func _input(event):
	if Input.is_action_just_pressed("dash") && direction != 0 && can_dash:
		input_blocked = true
		dashing = true
		can_dash = false
		animated_sprite.on_dash(DASH_TIME)
		await get_tree().create_timer(DASH_TIME).timeout
		input_blocked = false
		dashing = false

func apply_knockback(knockback_vector: Vector2):
	velocity = knockback_vector
	input_blocked = true
	animated_sprite.on_hit(0.2)