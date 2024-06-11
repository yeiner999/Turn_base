extends Node

# Referencias a la ui
@onready var ui_turn_label = $CanvasLayer/topContainer/turnPanel/Label
@onready var ui_message_label = $CanvasLayer/topContainer/messagePanel/Label
@onready var ui_container = $CanvasLayer/battleContainer
@onready var ui_skill_button = $CanvasLayer/battleContainer/VBoxContainer/skillButton
@onready var ui_skill_container = $CanvasLayer/battleContainer/skillsContainer
@onready var ui_skill1 = $CanvasLayer/battleContainer/skillsContainer/Button
@onready var ui_skill2 = $CanvasLayer/battleContainer/skillsContainer/Button2
@onready var ui_skill3 = $CanvasLayer/battleContainer/skillsContainer/Button3
@onready var ui_button1 = $CanvasLayer/battleContainer/VBoxContainer/attackButton
@onready var ui_button2 = $CanvasLayer/battleContainer/VBoxContainer/defendButton
@onready var ui_portrait = $CanvasLayer/battleContainer/charaPanel/VBoxContainer/TextureRect
@onready var ui_name = $CanvasLayer/battleContainer/charaPanel/VBoxContainer/Label
@onready var ui_player_data = $CanvasLayer/playersContainer
@onready var ui_enemy_data
@onready var battle_animation = $AnimationPlayer
@onready var animations = $animations

var ui_player_data_object = {}
var pred_message_label = "Piensalo bien"

var player_characters: Array[Character]
var enemy_characters: Array[Character]
# Referencias a los personajes
#@onready var player_characters: Array[Character] = [$character, $character2, $character3]
#var fallen_characters: Array[Character] = []
#@onready var enemy_characters: Array[Character] = [$enemy, $enemy2]
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
	
func _process(_delta):
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
	
	#self.connect("reproduce_external_animation", Callable(self, "_on_reproduce_external_animation"))
	Skills.connect("_calculate_damage", Callable(self, "calculate_attack_and_hit_target"))
	Skills.connect("reproduce_external_animation", Callable(self, "_on_reproduce_external_animation"))
	Skills.connect("await_external_animation", Callable(self, "await_battle_animation"))
	
	for character in player_characters + enemy_characters:
		character.connect("target_selected", Callable(self, "_on_target_selected"))
		character.connect("reproduce_external_animation", Callable(self, "_on_reproduce_external_animation"))
		character.connect("await_external_animation", Callable(self, "await_battle_animation"))

	state = BattleState.PLAYER_TURN
	
func _on_reproduce_external_animation(anim):
	await await_battle_animation()
	battle_animation.play(anim)
	await await_battle_animation()
	
	
func await_battle_animation() -> void:
	if battle_animation.is_playing():
		await battle_animation.animation_finished
		animations.visible = false
			
func calculate_attack_and_hit_target():
	var actual_damage = max(0, (Global.current_attacker.attack - Global.current_target.defense) * Global.current_multiplier)
	if Global.current_target.is_defending == true:
		actual_damage = actual_damage/2
	
	
	#print("atacante " + Global.current_attacker.character_name + " este es jugador? " + str(Global.current_attacker.is_player))
	#print("atacado " + Global.current_target.character_name + " este es jugador? " + str(Global.current_target.is_player))
	await await_battle_animation()
	# Reproducir la animación de recibir daño del objetivo
	Global.current_target.play_animation("hit")
	
	# Aplicar el daño al objetivo
	Global.current_target.take_damage(int(actual_damage))
	
	# Esperar a que la animación de recibir daño termine
	await Global.await_current_target_animation()
	

# Configuración de la UI
func _setup_ui():
	ui_container.visible = false
	ui_button1.connect("pressed", Callable(self, "_on_attack_button_pressed"))
	ui_button1.connect("mouse_entered", Callable(self, "_on_attack_mouse_entered"))
	ui_button1.connect("mouse_exited", Callable(self, "_on_attack_mouse_exited"))
	
	ui_button2.connect("pressed", Callable(self, "_on_defend_button_pressed"))
	ui_button2.connect("mouse_entered", Callable(self, "_on_defend_mouse_entered"))
	ui_button2.connect("mouse_exited", Callable(self, "_on_defend_mouse_exited"))
	
	ui_skill_button.connect("pressed", Callable(self, "_on_MenuButton_pressed"))
	
	ui_skill1.connect("pressed", Callable(self, "_on_hability1_button_pressed"))
	ui_skill1.connect("mouse_entered", Callable(self, "_on_hability1_mouse_entered"))
	ui_skill1.connect("mouse_exited", Callable(self, "_on_item_mouse_exited"))
	
	ui_skill2.connect("pressed", Callable(self, "_on_hability2_button_pressed"))
	ui_skill2.connect("mouse_entered", Callable(self, "_on_hability2_mouse_entered"))
	ui_skill2.connect("mouse_exited", Callable(self, "_on_item_mouse_exited"))
	
	ui_skill3.connect("pressed", Callable(self, "_on_hability3_button_pressed"))
	ui_skill3.connect("mouse_entered", Callable(self, "_on_hability3_mouse_entered"))
	ui_skill3.connect("mouse_exited", Callable(self, "_on_item_mouse_exited"))
	
	
	# Conectar la señal id_pressed a la función _on_item_pressed
	
	ui_message_label.text = pred_message_label
	
	create_character_ui()
	# Conectar el resto de botones aquí

func _on_MenuButton_pressed():
	# Obtén la posición global del menu_button
	#ui_skill_button.
	
	if !ui_skill_container.visible:
		ui_skill_container.visible = true
		return
		
	if ui_skill_container.visible:
		ui_skill_container.visible = false
		return
		

# Llama a esta función cuando se actualicen los arrays de personajes
func create_character_ui():
	# Añadir los personajes jugables
	for character in player_characters:
		var char_info
		if character.state == Global.CharaState.DEATH:
			char_info = create_character_info(character, true)
		else :
			char_info = create_character_info(character)
			
		char_info.connect("ui_target_selected", Callable(self, "_on_ui_target_selected"))
		ui_player_data.add_child(char_info)
		
		# Guarda el contenedor en el diccionario con una referencia al personaje
		ui_player_data_object[character] = char_info

func update_character_ui():
	# Añadir los personajes jugables
	for character in player_characters:
		var char_info = ui_player_data_object[character]
		if character.state == Global.CharaState.DEATH:
			update_character_info(char_info, character, true)
		else :
			update_character_info(char_info, character)
			

# Crear un HBoxContainer con la información del personaje
func create_character_info(character: Character, fallen = false):
	var char_info_pack = load("res://scenes/player_panel.tscn")
	var char_info = char_info_pack.instantiate()
	
	var label_name = char_info.get_node("VBoxContainer/nameLabel")
	label_name.text = character.character_name
	 # Cambiar el color del texto si el personaje está caído
	if fallen:
		label_name.add_theme_color_override("font_color", Color(1, 0, 0))
		char_info.alive = false
	
	var label_health = char_info.get_node("VBoxContainer/hpLabel")
	label_health.text = str(character.health)
	
	char_info.reference_character = character

	return char_info
	
func update_character_info(char_info, character: Character, fallen = false):
	
	var label_name = char_info.get_node("VBoxContainer/nameLabel")
	label_name.text = character.character_name
	 # Cambiar el color del texto si el personaje está caído
	if fallen:
		label_name.add_theme_color_override("font_color", Color(1, 0, 0))
		char_info.alive = false
	
	var label_health = char_info.get_node("VBoxContainer/hpLabel")
	label_health.text = str(character.health)

	return char_info

# Gestiona el turno del jugador
func _player_turn():
	if _is_battle_over():
		return

	if player_characters[current_turn_index]["state"] == Global.CharaState.DEATH:
		_end_turn()
		return
		
	await await_battle_animation()
	await Global.await_current_target_animation()
	
	Global.current_attacker = player_characters[current_turn_index]
	
	state = BattleState.PLAYER_TURN
	
	ui_skill_container.visible = false
	
		
	_show_action_buttons(Global.current_attacker)

func _show_action_buttons(attacker: Character):
	ui_name.text = attacker.character_name
	ui_portrait.texture = attacker.portrait
	ui_portrait.size.x = 320
	ui_button1.text = attacker.attack_name
	ui_button2.text = "Defenderse"
	
	ui_skill1.text = attacker.hability1_name
	ui_skill2.text = attacker.hability2_name
	ui_skill3.text = attacker.hability3_name
	
	ui_container.visible = true

# Lógica del botón de ataque
func _on_attack_mouse_entered():
	ui_message_label.text = Global.current_attacker.attack_description
	
func _on_attack_mouse_exited():
	ui_message_label.text = pred_message_label

func _on_attack_button_pressed():
	#var attacker = player_characters[current_turn_index]
	#attacker.attack_target(enemy_characters[enemy_current_turn_index], 3)
	#_end_turn()
	current_action = "button1"
	_show_target_selection(enemy_characters)

# Lógica del botón de defensa
func _on_defend_mouse_entered():
	ui_message_label.text = "El siguiente ataque que recibas hace menos daño"
	
func _on_defend_mouse_exited():
	ui_message_label.text = pred_message_label

func _on_defend_button_pressed():
	ui_container.visible = false
	Global.current_attacker.is_defending = true
	battle_animation.play("player_defend")
	await await_battle_animation()
	_end_turn()

func _on_item_mouse_exited():
	ui_message_label.text = pred_message_label
		
func _on_hability1_mouse_entered():
		ui_message_label.text = Global.current_attacker.hability1_description
		
func _on_hability1_button_pressed():
	#var attacker = player_characters[current_turn_index]
	#attacker.hability1()
	#_end_turn()
	current_action = "skill1"
	if Global.current_attacker.hability1_core_type == Global.TypeOfHability.SUPPORT:
		_show_ui_target_selection(ui_player_data.get_children())
	
	if Global.current_attacker.hability1_core_type == Global.TypeOfHability.ATTACK:
		_show_target_selection(enemy_characters)
	
func _on_hability2_mouse_entered():
		ui_message_label.text = Global.current_attacker.hability2_description
	
func _on_hability2_button_pressed():
	current_action = "skill2"
	if Global.current_attacker.hability2_core_type == Global.TypeOfHability.SUPPORT:
		_show_ui_target_selection(ui_player_data.get_children())
	
	if Global.current_attacker.hability2_core_type == Global.TypeOfHability.ATTACK:
		_show_target_selection(enemy_characters)
	
func _on_hability3_mouse_entered():
	ui_message_label.text = Global.current_attacker.hability3_description
	
func _on_hability3_button_pressed():
	current_action = "skill3"
	if Global.current_attacker.hability3_core_type == Global.TypeOfHability.SUPPORT:
		_show_ui_target_selection(ui_player_data.get_children())
	
	if Global.current_attacker.hability3_core_type == Global.TypeOfHability.ATTACK:
		_show_target_selection(enemy_characters)
	
# Mostrar selección de objetivo
func _show_target_selection(targets: Array):
	selecting_target = true
	ui_container.visible = false
	for character in targets:
		if character.state != Global.CharaState.DEATH:
			character.selecting_target = true
			
			
func _show_ui_target_selection(targets: Array):
	selecting_target = true
	ui_container.visible = false
	for character in targets:
		if character.alive:
			character.selecting_target = true

func  _on_ui_target_selected(target):
	selecting_target = false
	for child in ui_player_data.get_children():
			child.selecting_target = false
			child._set_highlight(false)
			
	#Global.current_target = target
	
	if current_action == "skill1":
		ui_message_label.text = Global.current_attacker.hability1_name
		await Global.current_attacker.hability1(target)
		await _await_all_and_reset_message_label()
	elif current_action == "skill2":
		ui_message_label.text = Global.current_attacker.hability2_name
		await Global.current_attacker.hability2(target)
		await _await_all_and_reset_message_label()
	elif current_action == "skill3":
		ui_message_label.text = Global.current_attacker.hability3_name
		await Global.current_attacker.hability3(target)
		await _await_all_and_reset_message_label()
	ui_container.visible = true
	_end_turn()

# Procesar selección de objetivo
func _on_target_selected(target):
	selecting_target = false
	for character in player_characters + enemy_characters:
			character.selecting_target = false
			character._set_highlight(false)
			
	Global.current_target = target
	
	Global.current_target.get_node("Label").visible = true
	
	if current_action == "button1":
		ui_message_label.text = Global.current_attacker.attack_name
		await Global.current_attacker.attack_target()
		
	elif current_action == "skill1":
		ui_message_label.text = Global.current_attacker.hability1_name
		await Global.current_attacker.hability1(target)
		
	elif current_action == "skill2":
		ui_message_label.text = Global.current_attacker.hability2_name
		await Global.current_attacker.hability2(target)
		
	elif current_action == "skill3":
		ui_message_label.text = Global.current_attacker.hability3_name
		await Global.current_attacker.hability3(target)
		
		
	await calculate_attack_and_hit_target()
	await _await_all_and_reset_message_label()
		
	Global.current_target.get_node("Label").visible = false
			
	ui_container.visible = true
	_end_turn()
	
# ir hacia atras
func _input(event):
	if event is InputEventMouseButton and selecting_target:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			for character in player_characters + enemy_characters + ui_player_data.get_children():
				character.selecting_target = false
				character._set_highlight(false)
				
			ui_skill_container.visible = false
			selecting_target = false
			_show_action_buttons(Global.current_attacker)
	
func _await_all_and_reset_message_label():
	await await_battle_animation()
	await Global.await_current_target_animation()
	_message_on_screen_reset()
	
func _message_on_screen_reset():
	ui_message_label.text = pred_message_label

# Finaliza el turno del jugador y pasa al siguiente turno
func _end_turn():
	ui_container.visible = false
	if Global.current_attacker.additional_turns > 0:
		Global.current_attacker.additional_turns -= 1
	else:
		current_turn_index += 1
		if current_turn_index > player_characters.size() - 1:
			current_turn_index = 0
			#await await_battle_animation()
			#await Global.await_current_target_animation()
			_enemy_turn()
			return
	ui_skill_container.visible = false
	_player_turn()
		
func _enemy_end_turn():
	enemy_current_turn_index += 1
	if enemy_current_turn_index > enemy_characters.size() - 1:
		enemy_current_turn_index = 0
		
		for player in player_characters:
			player.is_defending = false
		_player_turn()
		_update_effects()
		battle_turn += 1
		return
	else:
		#await await_battle_animation()
		#await Global.await_current_target_animation()
		_enemy_turn()

# Gestiona el turno del enemigo
func _enemy_turn():
	if _is_battle_over():
		return
		
	if enemy_characters[enemy_current_turn_index]["state"] == Global.CharaState.DEATH:
		_enemy_end_turn()
		return
		
	await await_battle_animation()
	await Global.await_current_target_animation()
	
	Global.current_attacker = enemy_characters[enemy_current_turn_index]
	
	state = BattleState.ENEMY_TURN
	
	await _enemy_logic()
	
	Global.current_attacker.additional_turns -= 1
	
	if Global.current_attacker.additional_turns >= 0:
		_enemy_turn()
	else:
		Global.current_attacker.additional_turns = Global.current_attacker.additional_turns_pred 
		_enemy_end_turn()
		
func _enemy_logic():
	var random_index = randi() % player_characters.size() - 1  # Genera un número aleatorio entre 0 y 2
	
	Global.current_target = player_characters[random_index]
	
	ui_message_label.text = Global.current_attacker.attack_name
	await Global.current_attacker.attack_target()
	await _await_all_and_reset_message_label()

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

func _update_effects():
	for character in player_characters + enemy_characters:
		character.update_effects()
# Finaliza la batalla
func _end_battle(result: String):
	var end_game_scene = load("res://scenes/gameover.tscn")
	Global.game_over_message = result
	# Cambiar la escena agregando la instancia de fin de partida
	get_tree().change_scene_to_packed(end_game_scene)
	
	
	
	
	print("Battle ended with result: " + result)
	# Implementar lógica de fin de batalla



