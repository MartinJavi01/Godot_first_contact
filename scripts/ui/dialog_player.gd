extends CanvasLayer

@export_file("*.json") var scene_dialogs: String

@onready var dialog_background = $DialogBackground
@onready var dialog_text = $DialogBackground/DialogText

var scene_text = {}
var current_text = []
var displaying = false

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
	if displaying:
		if current_text.size() > 0:
			show_text()
		else:
			finish()
	else:
		dialog_background.visible = true
		displaying = true
		current_text = scene_text[text_key].duplicate()
		show_text()

func show_text():
	dialog_text.text = current_text.pop_front()

func finish():
	displaying = false
	dialog_text.text = ""
	dialog_background.visible = false
