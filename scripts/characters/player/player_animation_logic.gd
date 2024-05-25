extends AnimatedSprite2D

@onready var player = $".."
@onready var attack_1_timer = $"../AttackLogicContainer/Attack1_Timer"
@onready var attack_2_timer = $"../AttackLogicContainer/Attack2_Timer"

func _process(delta):
	
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
