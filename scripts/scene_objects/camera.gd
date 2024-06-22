extends Camera2D

@onready var player = %player/player

@export var camera_smothness: float

func _process(delta):
	position = player.global_position
