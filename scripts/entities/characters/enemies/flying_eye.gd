extends Area2D

@onready var health_system = $HealthSystem

@export var attack_damage: float
@export var knockback_force: Vector2

func _process(delta):
	check_health()
	check_animations()
	
func check_movement(delta: float):
	pass
	
func check_health():
	if health_system.currentHealth == 0:
		queue_free()
	
func check_animations():
	pass

func _on_body_entered(body):
	if body is CharacterBody2D && body.name == "player":
		var healthSystem = body.get_node("HealthSystem")
		healthSystem.substract_health(attack_damage)
		var pos_dif = (self.global_position - body.global_position).normalized() * -10	
		body.apply_knockback(pos_dif * knockback_force)
