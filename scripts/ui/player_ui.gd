extends CanvasLayer

@onready var health_bar = $UIBG/HealthUIGB/HealthBar
@onready var coin_text = $UIBG/CoinUI/CoinText

var coins_updated = false

func _init():
	SignalBus.connect("update_player_health", update_player_health)
	SignalBus.connect("update_player_coins", update_player_coins)
	
func _process(delta):
	if !coins_updated:
		coins_updated = true
		update_player_coins(0)
		
func update_player_health(health_percentaje: float):
	health_bar.scale.x = health_percentaje

func update_player_coins(coin_sum: float):
	GlobalVars.current_coins += coin_sum
	if (GlobalVars.current_coins < 10):
		coin_text.text = "00" + str(GlobalVars.current_coins)
	elif (GlobalVars.current_coins < 100):
		coin_text.text = "0" + str(GlobalVars.current_coins)
	else:
		coin_text.text = str(GlobalVars.current_coins)
