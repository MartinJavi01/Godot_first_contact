extends Area2D

@export var dialog_key: String

@onready var interact_sound = $interact_sound
@onready var player = %player

var area_active = false

func _input(event):
	if event.is_action_pressed("interact") && area_active:
		player.get_node("DialogIndicator").visible = false
		interact_sound.play()
		SignalBus.emit_signal("display_dialog", dialog_key)

func _on_body_entered(body):
	if body is Player:
		area_active = true
		body.get_parent().get_node("DialogIndicator").visible = true

func _on_body_exited(body):
	if body is Player:
		area_active = false
		body.get_parent().get_node("DialogIndicator").visible = false
		SignalBus.emit_signal("exit_dialog")
