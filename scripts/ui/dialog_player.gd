extends CanvasLayer

@export_file("*.json") var scene_dialogs: String

@onready var dialog_background = $DialogBackground
@onready var dialog_text = $DialogBackground/DialogText

var scene_text = {}
var current_text = []
var displaying = false
var printing_text = false

func _ready():
	dialog_background.visible = false
	SignalBus.connect("display_dialog", on_display_dialog)
	SignalBus.connect("exit_dialog", finish)
	scene_text = load_dialog()
	
func load_dialog():
	if FileAccess.file_exists(scene_dialogs):
		var file = FileAccess.open(scene_dialogs, FileAccess.READ)
		var json = JSON.new()
		return json.parse_string(file.get_as_text())
	

func on_display_dialog(text_key):
	if Input.get_connected_joypads().size() > 0 && contains_key(text_key + "_controller"):
		text_key += "_controller"
	if displaying:
		if printing_text:
			printing_text = false
		else:
			if current_text.size() > 0:
				show_text()
			else:
				finish()
	else:
		dialog_background.visible = true
		displaying = true
		if contains_key(text_key):
			current_text = scene_text[text_key].duplicate()
		else:
			current_text = ["Dialog not found for key '" + text_key + "', at file '" + scene_dialogs + "'"]
		show_text()

func show_text():
	var current_string = current_text.pop_front()
	dialog_text.text = ""
	printing_text = true
	for c in current_string.split():
		if printing_text:
			dialog_text.text += c
			await get_tree().create_timer(0.025).timeout
		else:
			dialog_text.text = current_string
	printing_text = false

func finish():
	displaying = false
	dialog_text.text = ""
	dialog_background.visible = false
	
func contains_key(text_key):
	var contains = false
	for s in scene_text:
		if s == text_key:
			contains = true
	return contains
