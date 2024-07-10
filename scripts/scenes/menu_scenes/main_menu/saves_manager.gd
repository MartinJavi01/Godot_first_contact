extends Panel

@onready var save_1_button = $Save1Button
@onready var save_2_button = $Save2Button
@onready var save_3_button = $Save3Button

@onready var delete_save_1_button = $Save1Button/DeleteSave1Button
@onready var delete_save_2_button = $Save2Button/DeleteSave2Button
@onready var delete_save_3_button = $Save3Button/DeleteSave3Button

@onready var ui_accept = $"../../UIAccept"
@onready var ui_cancel = $"../../UICancel"

const new_game_string = "START NEW GAME"

func _ready():
	update_save_slots()

func _on_save_1_button_pressed():
	manage_save(1)

func _on_save_2_button_pressed():
	manage_save(2)

func _on_save_3_button_pressed():
	manage_save(3)
	
func _on_delete_save_1_button_pressed():
	delete_save_file(1)

func _on_delete_save_2_button_pressed():
	delete_save_file(2)

func _on_delete_save_3_button_pressed():
	delete_save_file(3)
	
func update_save_slots():
	if does_save_exist(1):
		delete_save_1_button.disabled = false
		update_save_slot(1, save_1_button)
	else:
		save_1_button.text = new_game_string
		delete_save_1_button.disabled = true
	
	if does_save_exist(2):
		delete_save_2_button.disabled = false
		update_save_slot(2, save_2_button)
	else:
		save_2_button.text = new_game_string
		delete_save_2_button.disabled = true
		
	if does_save_exist(3):
		delete_save_3_button.disabled = false
		update_save_slot(3, save_3_button)
	else:
		save_3_button.text = new_game_string
		delete_save_3_button.disabled = true
	
func update_save_slot(save_n: int, button: Button):
	var save_info = GlobalVars.load_save(save_n)
	button.text = "At {place} with {coins} coins".format({"place":save_info["current_scene_name"], "coins":save_info["current_coins"]},)
	
func does_save_exist(save_n:int):
	return FileAccess.file_exists(GlobalVars.SAVE_FILE_PATH_BASE.format({"n":str(save_n)}))

func manage_save(save_n: int):
	GlobalVars.current_save_n = save_n
	ui_accept.play()
	await get_tree().create_timer(0.5).timeout
	if does_save_exist(save_n):
		GlobalVars.set_global_vars(GlobalVars.load_save(save_n))
		get_tree().change_scene_to_file(GlobalVars.current_scene)
	else:
		get_tree().change_scene_to_file(GlobalVars.default_scene)

func delete_save_file(save_n):
	DirAccess.remove_absolute(GlobalVars.SAVE_FILE_PATH_BASE.format({"n":str(save_n)}))
	update_save_slots()
