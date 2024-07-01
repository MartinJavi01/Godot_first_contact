extends Node2D

@export var spawn_point_container: Node2D

@onready var player = %player

func _ready():
	GlobalVars.current_scene = scene_file_path
	move_player_to_spawn_pos(get_target_spawn_point().position)
		
func get_target_spawn_point():
	for spawn_point in spawn_point_container.get_children():
		if spawn_point.spawn_id == GlobalVars.target_spawn_point:
			return spawn_point

func move_player_to_spawn_pos(spawn_pos: Vector2):
	player.position = spawn_pos
	GlobalVars.target_spawn_point = 0

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu.tscn")
