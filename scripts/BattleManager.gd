extends Node

# Referencias a la ui
@onready var ui_turn_label = $CanvasLayer/topContainer/turnPanel/Label
@onready var ui_container = $CanvasLayer/MarginContainer/BoxContainer
@onready var ui_container_margin = $CanvasLayer/MarginContainer
@onready var ui_button1 = $CanvasLayer/MarginContainer/BoxContainer/Button
@onready var ui_button2 = $CanvasLayer/MarginContainer/BoxContainer/Button2
@onready var ui_button3 = $CanvasLayer/MarginContainer/BoxContainer/Button3
@onready var ui_button4 = $CanvasLayer/MarginContainer/BoxContainer/Button4
@onready var ui_button5 = $CanvasLayer/MarginContainer/BoxContainer/Button5
@onready var ui_player_data = $CanvasLayer/Panel/playableCharData
@onready var ui_enemy_data = $CanvasLayer/Panel/enemyCharData

# Referencias a los personajes
var player_characters: Array[Character] = []
#var fallen_characters: Array[Character] = []
var enemy_characters: Array[Character] = []
#var fallen_enemies: Array[Character] = []
var current_turn_index: int = 0
var enemy_current_turn_index: int = 0
var battle_turn: int = 1

# Enum para definir los estados del combate
enum BattleState {
	START,
	PLAYER_TURN,
	ENEMY_TURN,
	WIN,
	LOSE
}

var state = BattleState.START
var selecting_target = false
var current_action: String

func _ready():
	_initialize_battle()
	_setup_ui()
	_player_turn()
	
func _process(delta):
	_actualice_health()
	_actualice_health_enemy()
	_actualice_turn()
	update_character_ui()
	

#Actualiza turno
func _actualice_turn():
	if state == BattleState.PLAYER_TURN:
		ui_turn_label.text = "Turno " + str(battle_turn) + ": Jugador"
	if state == BattleState.ENEMY_TURN:
		ui_turn_label.text = "Turno " + str(battle_turn) + ": Enemigo"

# Actualiza salud
func _actualice_health():
	for player in player_characters:
		var label = player.get_node("Label")  # Asegúrate de que la ruta es correcta
		if label:
			label.text = str(player.health)  # Ejemplo de manipulación del Label
		#self.$Label.text = str(player.health)
		if player.health == 0:
			player.state = Global.CharaState.DEATH
	
# Actualiza salud enemigo
func _actualice_health_enemy():
	for enemy in enemy_characters:
		var label = enemy.get_node("Label")  # Asegúrate de que la ruta es correcta
		if label:
			label.text = str(enemy.health)  # Ejemplo de manipulación del Label
		#self.$Label.text = str(player.health)
		if enemy.health == 0:
			enemy.state = Global.CharaState.DEATH


# Inicializa la batalla
func _initialize_battle():
	player_characters.append($character)
	player_characters.append($character2)
	player_characters.append($character3)
	enemy_characters.append($enemy)
	enemy_characters.append($enemy2)
	
	for character in player_characters:
		character.connect("target_selected", Callable(self, "_on_target_selected"))
		
	for enemy in enemy_characters:
		enemy.connect("target_selected", Callable(self, "_on_target_selected"))

	state = BattleState.PLAYER_TURN
	

# Configuración de la UI
func _setup_ui():
	ui_container.visible = false
	ui_button1.connect("pressed", Callable(self, "_on_attack_button_pressed"))
	ui_button2.connect("pressed", Callable(self, "_on_defend_button_pressed"))
	ui_button3.connect("pressed", Callable(self, "_on_hability1_button_pressed"))
	ui_button4.connect("pressed", Callable(self, "_on_hability2_button_pressed"))
	ui_button5.connect("pressed", Callable(self, "_on_hability3_button_pressed"))
	
	update_character_ui()
	# Conectar el resto de botones aquí

# Llama a esta función cuando se actualicen los arrays de personajes
func update_character_ui():
	# Limpiar el contenedor de personajes jugables
	for child in ui_player_data.get_children():
		ui_player_data.remove_child(child)
		child.queue_free()

	# Limpiar el contenedor de personajes enemigos
	for child in ui_enemy_data.get_children():
		ui_enemy_data.remove_child(child)
		child.queue_free()

	# Añadir los personajes jugables
	for character in player_characters:
		var char_info
		if character.state == Global.CharaState.DEATH:
			char_info = create_character_info(character, true)
		else :
			char_info = create_character_info(character)
		ui_player_data.add_child(char_info)

	# Añadir los personajes enemigos
	for character in enemy_characters:
		var char_info
		if character.state == Global.CharaState.DEATH:
			char_info = create_character_info(character, true)
		else :
			char_info = create_character_info(character)
		ui_enemy_data.add_child(char_info)

# Crear un HBoxContainer con la información del personaje
func create_character_info(character: Character, fallen = false):
	var char_info = HBoxContainer.new()

	# Añadir el retrato del personaje
	var portrait = TextureRect.new()
	portrait.texture = character.portrait  # Asume que el objeto 'character' tiene una propiedad 'portrait'
	char_info.add_child(portrait)

	# Añadir los datos del personaje
	var vbox = VBoxContainer.new()
	
	var label_name = Label.new()
	label_name.text = character.character_name
	 # Cambiar el color del texto si el personaje está caído
	if fallen:
		label_name.add_theme_color_override("font_color", Color(1, 0, 0))

	vbox.add_child(label_name)
	
	var label_health = Label.new()
	label_health.text = str(character.health)
	vbox.add_child(label_health)
	
	char_info.add_child(vbox)

	return char_info
# Gestiona el turno del jugador
func _player_turn():
	if _is_battle_over():
		return

	if player_characters[current_turn_index]["state"] == Global.CharaState.DEATH:
		_end_turn()
		return
	
	Global.current_attacker = player_characters[current_turn_index]
	
	await Global.await_current_target_animation()
		
	_show_action_buttons(Global.current_attacker)

func _show_action_buttons(attacker: Character):
	ui_button1.text = attacker.attack_name
	ui_button2.text = "Defenderse"
	ui_button3.text = attacker.hability1_name
	ui_button4.text = attacker.hability2_name
	ui_button5.text = attacker.hability3_name
	
	ui_container.visible = true
	# Posicionar el MarginContainer cerca del personaje atacante
	var button_container = ui_container_margin
	#button_container.rect_min_size = Vector2(200, 100)  # Ajusta el tamaño del contenedor de botones # Ajusta el tamaño del contenedor de botones
	var new_position = Vector2(0, attacker.global_position.y)
	button_container.set_position(new_position)

# Lógica del botón de ataque
func _on_attack_button_pressed():
	#var attacker = player_characters[current_turn_index]
	#attacker.attack_target(enemy_characters[enemy_current_turn_index], 3)
	#_end_turn()
	current_action = "button1"
	_show_target_selection(enemy_characters)

# Lógica del botón de defensa
func _on_defend_button_pressed():
	Global.current_attacker.is_defending = true
	_end_turn()
	
func _on_hability1_button_pressed():
	#var attacker = player_characters[current_turn_index]
	#attacker.hability1()
	#_end_turn()
	current_action = "button2"
	_show_target_selection(player_characters)
	
func _on_hability2_button_pressed():
	var attacker = player_characters[current_turn_index]
	attacker.hability2()
	_end_turn()
	
func _on_hability3_button_pressed():
	var attacker = player_characters[current_turn_index]
	attacker.hability3()
	_end_turn()
	
# Mostrar selección de objetivo
func _show_target_selection(targets: Array):
	selecting_target = true
	ui_container.visible = false
	for character in targets:
		if character.state != Global.CharaState.DEATH:
			character.selecting_target = true

# Procesar selección de objetivo
func _on_target_selected(target):
	selecting_target = false
	for character in player_characters + enemy_characters:
			character.selecting_target = false
			character._set_highlight(false)
			
	Global.current_target = target
	
	if current_action == "button1":
		Global.calculate_multiplier(Global.current_attacker.attack_type)
		await Global.current_attacker.attack_target()
	elif current_action == "button2":
		await Global.current_attacker.hability1(target)
			
	ui_container.visible = true
	_end_turn()

# Finaliza el turno del jugador y pasa al siguiente turno
func _end_turn():
	ui_container.visible = false
	if Global.current_attacker.additional_turns > 0:
		Global.current_attacker.additional_turns -= 1
	else:
		current_turn_index += 1
		if current_turn_index > player_characters.size() - 1:
			current_turn_index = 0
			state = BattleState.ENEMY_TURN
			_enemy_turn()
			return

	_player_turn()
		
func _enemy_end_turn():
	enemy_current_turn_index += 1
	if enemy_current_turn_index > enemy_characters.size() - 1:
		enemy_current_turn_index = 0
		state = BattleState.PLAYER_TURN
		
		for player in player_characters:
			player.is_defending = false
		_player_turn()
		battle_turn += 1
		return
	else:
		_enemy_turn()

# Gestiona el turno del enemigo
func _enemy_turn():
	if _is_battle_over():
		return
		
	if enemy_characters[enemy_current_turn_index]["state"] == Global.CharaState.DEATH:
		_enemy_end_turn()
		return
	
	Global.current_attacker = enemy_characters[enemy_current_turn_index]
	
	await Global.await_current_target_animation()
	
	var random_index = randi() % player_characters.size() - 1  # Genera un número aleatorio entre 0 y 2
	
	Global.current_target = player_characters[random_index]
	
	Global.calculate_multiplier(Global.current_attacker.attack_type)
	
	await Global.current_attacker.attack_target()
	
	if Global.current_attacker.additional_turns > 0:
		Global.current_attacker.additional_turns -= 1
		_enemy_turn()
	else:
		Global.current_attacker.additional_turns = Global.current_attacker.additional_turns_pred 
		_enemy_end_turn()

# Comprueba si la batalla ha terminado
func _is_battle_over() -> bool:
	var all_players_dead = true
	for player in player_characters:
		if player.health > 0:
			all_players_dead = false
			break
	
	var all_enemies_dead = true
	for enemy in enemy_characters:
		if enemy.health > 0:
			all_enemies_dead = false
			break

	if all_players_dead:
		state = BattleState.LOSE
		_end_battle("Perdiste")
		return true

	if all_enemies_dead:
		state = BattleState.WIN
		_end_battle("Ganaste")
		return true

	return false

# Finaliza la batalla
func _end_battle(result: String):
	var end_game_scene = load("res://scenes/gameover.tscn")
	Global.game_over_message = result
	# Cambiar la escena agregando la instancia de fin de partida
	get_tree().change_scene_to_packed(end_game_scene)
	
	
	
	
	print("Battle ended with result: " + result)
	# Implementar lógica de fin de batalla
