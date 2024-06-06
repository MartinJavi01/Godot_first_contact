extends Sprite2D

@onready var main_camera = %MainCamera

@export var parallax: float

var startPos
var width
var moveOffset
var totalDist

func _ready():
	startPos = global_position.x
	totalDist = 0.0
	width = texture.get_width() * scale.x
	
func _process(delta):
	moveOffset = main_camera.global_position.x * parallax
	totalDist = main_camera.global_position.x * (1 - parallax)
	
	global_position.x = startPos + moveOffset
	if totalDist > width + startPos:
		startPos += width
	elif totalDist < -width + startPos:
		startPos -= width
