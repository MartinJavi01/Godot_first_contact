extends Camera2D

@onready var player = %player/player

func _ready():
	position_smoothing_enabled = false
	position = player.global_position
	await get_tree().create_timer(0.5).timeout
	position_smoothing_enabled = true

func _process(delta):
	position = player.global_position
