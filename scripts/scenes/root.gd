extends Node2D

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu.tscn")
