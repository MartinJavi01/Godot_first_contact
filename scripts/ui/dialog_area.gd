extends Area2D

@export var dialog_key: String
@onready var interact_sound = $interact_sound

var area_active = false

func _input(event):
	if event.is_action_pressed("interact"):
		interact_sound.play()
		UiSignals.emit_signal("display_dialog", dialog_key)

func _on_body_entered(body):
	area_active = true

func _on_body_exited(body):
	area_active = false
	UiSignals.emit_signal("exit_dialog")
