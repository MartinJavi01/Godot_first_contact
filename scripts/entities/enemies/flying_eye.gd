extends CharacterBody2D

@onready var health_system = $HealthSystem
@onready var player = %player
@onready var animated_sprite = $AnimatedSprite2D
@onready var wing_sound = $Sounds/WingSound
@onready var hurt_sound = $Sounds/HurtSound
@onready var death_sound = $Sounds/DeathSound

@export var follow_range: float
@export var move_speed: float
@export var attack_damage: float
@export var knockback_force: Vector2
@export var affected_layers = [8]

var target_pos
var preparing_attack
var attacking

func _ready():
	target_pos = Vector2(player.global_position.x, player.global_position.y - 60.0)
	preparing_attack = false
	attacking = false

func _physics_process(delta):
	if !wing_sound.playing:
		wing_sound.play()
	
	check_health()
	check_movement(delta)
	check_animations()
	
	move_and_slide()
	
func check_movement(delta):
	if !attacking && health_system.currentHealth > 0:
		target_pos = Vector2(player.global_position.x, player.global_position.y - 60.0)
		if player_in_range():
			global_position = global_position.move_toward(target_pos if !preparing_attack else Vector2(global_position.x, global_position.y), delta * move_speed)
			if global_position.distance_to(target_pos) < 10.0:
				prepare_attack()
		else:
			preparing_attack = false
	else:
		global_position = global_position.move_toward(target_pos, delta * move_speed)
		
func player_in_range():
	return global_position.distance_to(target_pos) > 10.0 && global_position.distance_to(target_pos) < follow_range

func prepare_attack():
	if !preparing_attack:
		preparing_attack = true
		await get_tree().create_timer(0.5).timeout
		if player_in_range() || global_position.distance_to(target_pos) <= 10.0:
			target_pos = Vector2(global_position.x, player.global_position.y - 20.0)
			attacking = true	
		preparing_attack = false 
	
	if attacking:
		await get_tree().create_timer(1).timeout
		attacking = false
	
func check_animations():
	animated_sprite.flip_h = true if (global_position.x - player.global_position.x > 0) else false

func check_health():
	if health_system.currentHealth <= 0 && !death_sound.playing:
		hurt_sound.stop()
		death_sound.play()
		await get_tree().create_timer(0.6).timeout
		queue_free()

func _on_hitbox_body_entered(body):
	if body is CharacterBody2D && body.name == "player":
		var playerHealthSystem = body.get_node("HealthSystem")
		if playerHealthSystem.currentHealth > 0:
			playerHealthSystem.substract_health(attack_damage)
			var knockback_vector = Vector2(1 if global_position.x < body.global_position.x else -1, 1) * knockback_force
			body.apply_knockback(knockback_vector)
			await get_tree().create_timer(0.5).timeout
			attacking = false

func _on_hitbox_area_entered(area):
	if affected_layers.find(area.get_collision_layer() as int) != -1:
		hurt_sound.play()
