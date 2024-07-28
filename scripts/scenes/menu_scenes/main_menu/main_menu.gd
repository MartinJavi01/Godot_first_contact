extends Node2D

@onready var animation_player = $MainUI/AnimationPlayer
@onready var master_volume_slider = $MainUI/SettingsPanel/MasterVolumeSetting/MasterVolumeSlider
@onready var music_volume_slider = $MainUI/SettingsPanel/MusicVolumeSetting/MusicVolumeSlider
@onready var sfx_volume_slider = $MainUI/SettingsPanel/SFXVolumeSetting/SFXVolumeSlider
@onready var ui_accept = $UIAccept
@onready var ui_cancel = $UICancel
@onready var play_button = $MainUI/MainButtonsPanel/PlayButton
@onready var save_1_button = $MainUI/LoadGamePanel/Save1Button
@onready var main_buttons_panel = $MainUI/MainButtonsPanel
@onready var settings_panel = $MainUI/SettingsPanel
@onready var load_game_panel = $MainUI/LoadGamePanel

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

var current_menu = 0

func _ready():
	get_window().grab_focus()
	settings_panel.visible = false
	load_game_panel.visible = false
	animation_player.play("RESET")
	master_volume_slider.value = (AudioServer.get_bus_volume_db(master_bus_index) + 24) * 3.33
	music_volume_slider.value = (AudioServer.get_bus_volume_db(music_bus_index) + 24) * 3.33
	sfx_volume_slider.value = (AudioServer.get_bus_volume_db(sfx_bus_index) + 24) * 3.33
	if !DirAccess.dir_exists_absolute(GlobalVars.SAVE_DIR_PATH):
		DirAccess.make_dir_absolute(GlobalVars.SAVE_DIR_PATH)
	
	if Input.get_connected_joypads().size() > 0:
		play_button.grab_focus()
	Input.joy_connection_changed.connect(on_joycon_connection_change)
	

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
		
# Button functions
func _on_play_button_pressed():
	load_game_panel.visible = true
	ui_accept.play()
	animation_player.play("main_to_saves")
	await animation_player.animation_finished
	main_buttons_panel.visible = false
	save_1_button.grab_focus()
	current_menu = 1
	

func _on_settings_button_pressed():
	settings_panel.visible = true
	ui_accept.play()
	animation_player.play("main_to_settings")
	await animation_player.animation_finished
	main_buttons_panel.visible = false
	master_volume_slider.grab_focus()
	current_menu = 2
	
func _on_exit_button_pressed():
	ui_cancel.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
	
func _on_settings_back_button_pressed():
	main_buttons_panel.visible = true
	ui_cancel.play()
	animation_player.play("settings_to_main")
	await animation_player.animation_finished
	settings_panel.visible = false
	play_button.grab_focus()
	current_menu = 0

func _on_saves_back_button_pressed():
	main_buttons_panel.visible = true
	ui_cancel.play()
	animation_player.play("saves_to_main")
	await animation_player.animation_finished
	load_game_panel.visible
	play_button.grab_focus()
	current_menu = 0

func on_joycon_connection_change(device: int, connected: bool):
	match current_menu:
		0:
			play_button.grab_focus()
			if !connected:
				play_button.release_focus()
		1:
			save_1_button.grab_focus()
			if !connected:
				save_1_button.release_focus()
		2:
			master_volume_slider.grab_focus()
			if !connected:
				master_volume_slider.release_focus()

func _input(event):
	if Input.get_connected_joypads().size() > 0:
		if Input.is_action_just_pressed("ui_cancel"):
			match current_menu:
				0:
					_on_exit_button_pressed()
				1:
					_on_saves_back_button_pressed()
				2:
					_on_settings_back_button_pressed()
