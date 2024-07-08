extends Node

# UI signals
signal display_dialog(dialog_key)
signal exit_dialog()

# Player signals
signal update_player_health(hp_percentaje)
signal update_player_coins(coin_sum)

# Game save signals
signal save_game_vars()
