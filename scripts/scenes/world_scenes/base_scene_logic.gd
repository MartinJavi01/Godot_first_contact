extends Node2D

@export var spawn_point_container: Node2D

@onready var player = %player
@onready var scene_transition_rect = %SceneTransitionRect

func _ready():
	scene_transition_rect.get_child(0).play("scene_entry")
	GlobalVars.current_scene = scene_file_path
	move_player_to_spawn_pos(get_target_spawn_point())
		
func get_target_spawn_point():
	for spawn_point in spawn_point_container.get_children():
		if spawn_point.spawn_id == GlobalVars.target_spawn_point:
			return spawn_point

func move_player_to_spawn_pos(spawn_point: SpawnPoint):
	player.position = spawn_point.position
	if !spawn_point.facing_right:
		player.get_child(0).scale.x = -1
		player.get_child(0).previous_direction = -1
	GlobalVars.target_spawn_point = 0

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu.tscn")
