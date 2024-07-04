extends AnimatedSprite2D

@onready var player = $".."
@onready var attack_1_timer = $"../AttackLogicContainer/Attack1_Timer"
@onready var attack_2_timer = $"../AttackLogicContainer/Attack2_Timer"
@onready var health_system = $"../HealthSystem"
@onready var death_sound = $"../SFXSounds/DeathSound"

var on_action = false

func _process(delta):
	if !on_action:
		if health_system.currentHealth > 0:
			if attack_1_timer.is_stopped() && attack_2_timer.is_stopped():
				if player.is_on_floor():
					if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
						play("crouch_walk") if player.crouching else play("walk")
					else:
						play("crouch_idle") if player.crouching else play("idle")
				else:
					if player.velocity.y < 0:
						play("jump")
					else:
						play("fall")
			else:
				play("attack_1" if !attack_1_timer.is_stopped() else "attack_2")
		else:
			check_death()
		
func on_hit(knockback_time: float):
	on_action = true
	play("hit")
	await get_tree().create_timer(knockback_time).timeout
	player.input_blocked = false
	on_action = false

func on_dash(dash_time: float):
	on_action = true
	play("crouch_dash") if player.crouching else play("dash")
	await get_tree().create_timer(dash_time).timeout
	on_action = false

func check_death():
	if animation != "death":
		death_sound.play()
		play("death")
		await animation_finished
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu.tscn")
