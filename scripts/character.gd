extends Node2D

class_name Character

# Propiedades del personaje
var character_name: String = "dummy"
var health: int = 100
var max_health: int = 100
var attack: int = 10
var defense: int = 5
var order: int = 0
var state: Global.CharaState = Global.CharaState.ALIVE
var is_player: bool = true
var is_selected: bool = false
var is_defending: bool = false
var resistance: Array[Global.TypeOfDamage] = [Global.TypeOfDamage.PHYSICAL]
var weakness: Array[Global.TypeOfDamage] = [Global.TypeOfDamage.MAGICAL]
var strength: Array[Global.TypeOfDamage] = [Global.TypeOfDamage.PHYSICAL]
var inmunity: Array[Global.TypeOfDamage] = [Global.TypeOfDamage.ILLUSORY]
var additional_turns: int = 0
var additional_turns_pred: int = 0
var portrait = load("res://graphics/battle/characters/portrait.png")
var reference_ui
var current_attack: Global.CurrentAttack 

@onready var health_bar = $health

var effects: Array = []

# Bandera para habilitar la selección de objetivos
var selecting_target: bool = false

# habilidades
var attack_name: String = "Ataque Perforante"
var attack_description: String = "Ataque Perforante"
var attack_type: Global.TypeOfDamage = Global.TypeOfDamage.PHYSICAL

var hability1_name: String = "habilidad 1"
var hability1_description: String = "habilidad 1"
var hability1_core_type: Global.TypeOfHability = Global.TypeOfHability.SUPPORT
var hability1_type: Global.TypeOfDamage = Global.TypeOfDamage.NONE
var hability1_damage: int = 0

var hability2_name: String = "habilidad 2"
var hability2_description: String = "habilidad 2"
var hability2_core_type: Global.TypeOfHability = Global.TypeOfHability.ATTACK
var hability2_type: Global.TypeOfDamage = Global.TypeOfDamage.PHYSICAL
var hability2_damage: int = 0

var hability3_name: String = "habilidad 3"
var hability3_description: String = "habilidad 3"
var hability3_core_type: Global.TypeOfHability = Global.TypeOfHability.ATTACK
var hability3_type: Global.TypeOfDamage = Global.TypeOfDamage.PHYSICAL
var hability3_damage: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
	
func play_animation(animation_name: String) -> void:
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)

func apply_effect(effect: Effect):
	var existing_effect = null
	
	for current_effect in effects:
		if current_effect.effect_name == effect.effect_name:
			existing_effect = current_effect
			break
			
	if existing_effect:
		existing_effect.duration += effect.duration
	else:
		effects.append(effect)
		effect.apply_effect.call(self)

func update_effects():
	for effect in effects:
		effect.duration -= 1
		if effect.duration < 1:
			effect.remove_effect.call(self)
			effects.erase(effect)
			print("efecto borrado")
			return
		effect.apply_effect.call(self)
		

# Método para recibir daño
func take_damage(damage: int) -> void:
	health -= damage
	if health < 0:
		health = 0
		
func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health

func calculate_attack_and_hit_target():
	var attack_multi = 1
	
	if Global.current_attacker.current_attack == Global.CurrentAttack.ATTACK:
		attack_multi = 1
		
	if Global.current_attacker.current_attack == Global.CurrentAttack.SKILL1:
		attack_multi = Global.current_attacker.hability1_damage
		
	if Global.current_attacker.current_attack == Global.CurrentAttack.SKILL2:
		attack_multi = Global.current_attacker.hability2_damage
		
	if Global.current_attacker.current_attack == Global.CurrentAttack.SKILL3:
		attack_multi = Global.current_attacker.hability3_damage
		
	
	var actual_damage = max(0, (Global.current_attacker.attack * attack_multi - Global.current_target.defense) * Global.current_multiplier)
	if Global.current_target.is_defending == true:
		actual_damage = actual_damage/2
		
	actual_damage = int(actual_damage)
	
	var damage_string = str(actual_damage)
	
	if actual_damage == 0:
		damage_string = "Bloqueado"
		
	Global.display_damage(damage_string, Global.current_target.reference_ui.get_node("Marker2D").global_position)
	
	# Reproducir la animación de recibir daño del objetivo
	emit_signal("reproduce_external_animation", "screen_shake")
		
	# Aplicar el daño al objetivo
	Global.current_target.take_damage(actual_damage)
	

# Método para atacar a otro personaje
func attack_target() -> void:
	current_attack = Global.CurrentAttack.ATTACK
	Global.calculate_multiplier(Global.current_attacker.attack_type)
	#await Global.await_current_target_animation()
	# Reproducir la animación de ataque del atacante
	#play_animation("attack")
	#if Global.current_attacker:
		#print("atacante " + Global.current_attacker.character_name + " este es jugador? " + str(Global.current_attacker.is_player))
		
	#if Global.current_target:
		#print("atacado " + Global.current_target.character_name + " este es jugador? " + str(Global.current_target.is_player))
	if Global.current_attacker.is_player:
		emit_signal("reproduce_external_animation", "player_attack_basic")
		emit_signal("await_external_animation")
		return
	else:
		play_animation("attack")
		await animation_player.animation_finished
	
	
	

func support_target(target: Character, property, value):
	target[property] += value
	
func hability1(target: Character):
	current_attack = Global.CurrentAttack.SKILL1
	print("1")
	
func hability2(target: Character):
	current_attack = Global.CurrentAttack.SKILL2
	print("2")
	
func hability3(target: Character):
	current_attack = Global.CurrentAttack.SKILL3
	print("3")
	

func _ready():
	$Area2D.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	$Area2D.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	$Area2D.connect("input_event", Callable(self, "_on_input_event"))
	
	health_bar.max_value = health
	health_bar.value = health
	
func _process(_delta):
	health_bar.value = health

func _on_mouse_entered():
	if selecting_target:
		_set_highlight(true)

func _on_mouse_exited():
	if selecting_target:
		_set_highlight(false)

func _on_input_event(_viewport, event, _shape_idx):
	if selecting_target and event is InputEventMouseButton and event.pressed:
		emit_signal("target_selected", self)

func _set_highlight(enabled: bool):
	if enabled:
		$Sprite2D.modulate = Color(1, 1, 1, 0.5)  # Cambia la transparencia o color del sprite para resaltar
		#$focus.visible = true
		$health.visible = true
	else:
		$Sprite2D.modulate = Color(1, 1, 1, 1)  # Vuelve al color original
		#$focus.visible = false
		$health.visible = false
		
func _reproduce_external_animation(anim):
	emit_signal("reproduce_external_animation", anim)

signal target_selected(character)
signal reproduce_external_animation(anim)
signal await_external_animation()
