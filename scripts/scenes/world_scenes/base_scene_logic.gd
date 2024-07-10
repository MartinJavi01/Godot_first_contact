extends Node2D

@export var spawn_point_container: Node2D
@export var scene_name: String

@onready var player = %player
@onready var scene_transition_rect = %SceneTransitionRect

func _ready():
	GlobalVars.current_scene_name = scene_name
	GlobalVars.current_scene = scene_file_path
	SignalBus.connect("save_game_vars", update_current_scene)
	scene_transition_rect.modulate = Color(0,0,0,255)
	scene_transition_rect.get_child(0).play("scene_entry")
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

func update_current_scene():
	GlobalVars.current_scene = scene_file_path

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu.tscn")
