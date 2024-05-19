extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const MOVE_SPEED = 200.0
const JUMP_FORCE = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	check_movement(delta)
	
	move_and_slide()
	update_animations()

func check_movement(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * MOVE_SPEED
		animated_sprite.flip_h = direction == -1
	else:
		velocity.x = lerp(velocity.x, 0.0, 1)
		
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE

func update_animations():
	if !is_on_floor():
		if velocity.y < 10:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	else:
		if velocity.x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
