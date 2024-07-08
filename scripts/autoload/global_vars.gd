extends Node2D

# Signals


# CONSTS
const SAVE_FILE_PATH = "res://saves/save.json"

# SCENE VARS
var target_spawn_point = 0
var current_spawn_point = 0
var current_scene = ""
var default_scene = "res://scenes/world_scenes/oak_woods_1.tscn."

# PLAYER VARS
var current_coins = 0
var current_health = 0

func get_save_data():
	return {
		current_spawn_point = current_spawn_point,
		current_scene = current_scene,
		current_coins = current_coins
	}

func load_save():
	var save_file = FileAccess.open(GlobalVars.SAVE_FILE_PATH, FileAccess.READ)
	var game_config = JSON.parse_string(save_file.get_as_text())
	GlobalVars.current_coins = game_config["current_coins"]
	GlobalVars.target_spawn_point = game_config["current_spawn_point"]
	GlobalVars.current_spawn_point = game_config["current_spawn_point"]
	GlobalVars.current_scene = game_config["current_scene"]
	get_tree().change_scene_to_file(GlobalVars.current_scene)
