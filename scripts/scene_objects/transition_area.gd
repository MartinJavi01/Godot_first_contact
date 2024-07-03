extends Area2D

@export_file var target_scene: String
@export var target_point: int

@onready var scene_transition_rect = %SceneTransitionRect
@onready var player = %player/player

func _on_body_entered(body):
	if body is Player:
		scene_transition_rect.get_child(0).play("scene_transition")
		player.input_blocked = true
		await scene_transition_rect.get_child(0).animation_finished
		GlobalVars.target_spawn_point = target_point
		get_tree().change_scene_to_file(target_scene)
