extends "res://scripts/BattleManager.gd"

func _ready():
	player_characters = [$character, $character2, $character3]
	enemy_characters = [$enemy, $enemy2]
	super._ready()

func _enemy_logic():
	print("yes")
	var random_index = randi() % player_characters.size() - 1  # Genera un número aleatorio entre 0 y 2
	
	Global.current_target = player_characters[random_index]
	
	ui_message_label.text = Global.current_attacker.attack_name
	await Global.current_attacker.attack_target()
	await _await_all_and_reset_message_label()
