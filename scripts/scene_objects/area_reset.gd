extends Area2D

@export var resetTime: float

func _on_body_entered(body):
	if body is Player:
		await get_tree().create_timer(resetTime).timeout
		GlobalVars.target_spawn_point = GlobalVars.current_spawn_point
		get_tree().change_scene_to_file(GlobalVars.current_scene)
