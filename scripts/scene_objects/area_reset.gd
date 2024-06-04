extends Area2D

@export var resetTime: float

func _on_body_entered(body):
	if body.name == "player":
		await get_tree().create_timer(resetTime).timeout
		get_tree().reload_current_scene()
