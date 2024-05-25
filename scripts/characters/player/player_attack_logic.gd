extends Node2D

@onready var player = $".."
@onready var attack_1_timer = $Attack1_Timer
@onready var attack_1_shape = $Attack1_Hitbox/Attack_1_Shape
@onready var attack_2_timer = $Attack2_Timer

var attack_again = false

func _process(delta):
	if player.is_on_floor():
		if Input.is_action_just_pressed("attack"):
			if attack_1_timer.is_stopped() && attack_2_timer.is_stopped():
				attack_1_timer.start()
			if can_attackAgain():
				attack_again = true
	
	attack_1_shape.disabled = attack_1_timer.is_stopped() && attack_2_timer.is_stopped()

func can_attackAgain():
	return  attack_1_timer.time_left < (attack_1_timer.wait_time / 3)
	
func _on_attack_1_timer_timeout():
	if attack_again:
		attack_again = false
		attack_2_timer.start()
