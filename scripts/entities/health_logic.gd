extends Node2D

@onready var animated_sprite = $"../AnimatedSprite2D"
@onready var parent = $"../.."

@export var maxHealth: float

var currentHealth

func _ready():
	currentHealth = maxHealth

func set_current_heath(value: float):
	if value < maxHealth:
		currentHealth = value

func set_current_health_percentaje(value: int):
	if value < 101 && value > -1:
		currentHealth = maxHealth * (value / 100.0)
		
func substract_health(value: float):
	currentHealth -= value
	if currentHealth < 0:
		currentHealth = 0
