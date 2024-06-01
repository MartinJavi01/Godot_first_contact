extends AnimatedSprite2D

@onready var player = $".."
@onready var attack_1_timer = $"../AttackLogicContainer/Attack1_Timer"
@onready var attack_2_timer = $"../AttackLogicContainer/Attack2_Timer"
@onready var health_system = $"../HealthSystem"

var hit = false

func _process(delta):
	if health_system.currentHealth > 0:
		if attack_1_timer.is_stopped() && attack_2_timer.is_stopped():
			if player.is_on_floor():
				if player.velocity.x != 0:
					play("walk")
				else:
					play("idle")
			else:
				if player.velocity.y < 0:
					play("jump")
				else:
					play("fall")
		else:
			play("attack_1" if !attack_1_timer.is_stopped() else "attack_2")
		if hit:
			play("hit")
	else:
		check_death()
		
func on_hit(knockback_time: float):
	hit = true
	play("hit")
	await get_tree().create_timer(knockback_time).timeout
	player.input_blocked = false
	hit = false

func check_death():
	if animation != "death":
		play("death")
		await animation_finished
		get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu.tscn")
