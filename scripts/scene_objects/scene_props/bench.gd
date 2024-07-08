extends Sprite2D

@export var spawn_id: int

var can_save = false

func _input(event):
	if event.is_action_pressed("save") && can_save:
		SignalBus.emit_signal("save_game_vars")
		GlobalVars.current_spawn_point = spawn_id
		var save_file = FileAccess.open(GlobalVars.SAVE_FILE_PATH, FileAccess.WRITE)
		save_file.store_string(JSON.stringify(GlobalVars.get_save_data()))
		save_file.close()

func _on_area_2d_body_entered(body):
	if body is Player:
		can_save = true


func _on_area_2d_body_exited(body):
	if body is Player:
		can_save = false
