extends Node2D

# CONSTS
const SAVE_DIR_PATH = "user://saves"
const SAVE_FILE_PATH_BASE = "user://saves/save{n}.json"
const default_scene = "res://scenes/world_scenes/oak_woods_1.tscn"

# SCENE VARS
var current_save_n = 0
var target_spawn_point = 0
var current_spawn_point = 0
var current_scene = ""
var current_scene_name = ""

# PLAYER VARS
var current_coins = 0
var current_health = 0

func get_save_data():
	return {
		current_spawn_point = current_spawn_point,
		current_scene = current_scene,
		current_scene_name = current_scene_name,
		current_coins = current_coins
	}

func load_save(save_n: int):
	var save_file = FileAccess.open(SAVE_FILE_PATH_BASE.format({"n":str(save_n)}), FileAccess.READ)
	return JSON.parse_string(save_file.get_as_text())
	
func set_global_vars(game_config: Dictionary):
	GlobalVars.current_coins = game_config["current_coins"]
	GlobalVars.target_spawn_point = game_config["current_spawn_point"]
	GlobalVars.current_spawn_point = game_config["current_spawn_point"]
	GlobalVars.current_scene = game_config["current_scene"]
	GlobalVars.current_scene_name = game_config["current_scene_name"]
