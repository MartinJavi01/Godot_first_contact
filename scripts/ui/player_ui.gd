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
	GlobalVars.CURRENT_COINS += coin_sum
	if (GlobalVars.CURRENT_COINS < 10):
		coin_text.text = "00" + str(GlobalVars.CURRENT_COINS)
	elif (GlobalVars.CURRENT_COINS < 100):
		coin_text.text = "0" + str(GlobalVars.CURRENT_COINS)
	else:
		coin_text.text = str(GlobalVars.CURRENT_COINS)
