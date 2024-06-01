extends Node2D

@onready var player = $".."
@onready var attack_1_timer = $Attack1_Timer
@onready var attack_1_shape = $Attack1_Hitbox/Attack_1_Shape
@onready var attack_2_timer = $Attack2_Timer

@export var damage: float

var attack_again = false

func _process(delta):
	if player.is_on_floor():
		if Input.is_action_just_pressed("attack"):
			if attack_1_timer.is_stopped() && attack_2_timer.is_stopped():
				player.input_blocked = true
				player.velocity.x = 0
				attack_1_timer.start()
			if can_attackAgain():
				attack_again = true
	
	attack_1_shape.disabled = !hitbox_active()
		
func hitbox_active():
	var timer_1_on_range = 0.1 < attack_1_timer.time_left && attack_1_timer.time_left < attack_1_timer.wait_time * 0.7
	var timer_2_on_range = 0.1 < attack_2_timer.time_left && attack_2_timer.time_left < attack_2_timer.wait_time * 0.7
	return timer_1_on_range || timer_2_on_range

func can_attackAgain():
	return  attack_1_timer.time_left < (attack_1_timer.wait_time / 2)
	
# SIGNALS
func _on_attack_1_timer_timeout():
	if attack_again:
		attack_again = false
		attack_2_timer.start()
	else:
		player.input_blocked = false

func _on_attack_2_timer_timeout():
	player.input_blocked = false

func _on_attack_1_hitbox_area_entered(area):
	var health_node = area.get_node("HealthSystem")
	health_node.substract_health(damage)
