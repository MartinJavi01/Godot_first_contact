extends Node2D

@onready var animation_player = $MainUI/AnimationPlayer
@onready var master_volume_slider = $MainUI/SettingsPanel/MasterVolumeSetting/MasterVolumeSlider
@onready var music_volume_slider = $MainUI/SettingsPanel/MusicVolumeSetting/MusicVolumeSlider
@onready var sfx_volume_slider = $MainUI/SettingsPanel/SFXVolumeSetting/SFXVolumeSlider
@onready var ui_accept = $UIAccept
@onready var ui_cancel = $UICancel

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

func _ready():
	master_volume_slider.value = (AudioServer.get_bus_volume_db(master_bus_index) + 24) * 3.33
	music_volume_slider.value = (AudioServer.get_bus_volume_db(music_bus_index) + 24) * 3.33
	sfx_volume_slider.value = (AudioServer.get_bus_volume_db(sfx_bus_index) + 24) * 3.33
	
## Main menu funcitons
func _on_play_button_pressed():
	ui_accept.play()
	await get_tree().create_timer(0.5).timeout
	if FileAccess.file_exists(GlobalVars.SAVE_FILE_PATH):
		GlobalVars.load_save()
	else:
		get_tree().change_scene_to_file("res://scenes/world_scenes/oak_woods_1.tscn")

func _on_settings_button_pressed():
	ui_accept.play()
	animation_player.play("main_to_settings")

func _on_back_button_pressed():
	ui_cancel.play()
	animation_player.play("settings_to_main")
	
func _on_exit_button_pressed():
	ui_cancel.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

## Settings functions
func _on_master_volume_slider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_volume_db(master_bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(master_bus_index, (value * 0.3) - 24)

func _on_music_volume_slider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_volume_db(music_bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(music_bus_index, (value * 0.3) - 24)

func _on_sfx_volume_slider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_volume_db(sfx_bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(sfx_bus_index, (value * 0.3) - 24)
