extends Area2D

@export var target_scene: String
@export var target_point: int

func _on_body_entered(body):
	if body is Player:
		GlobalVars.target_spawn_point = target_point
		get_tree().change_scene_to_file(target_scene)
