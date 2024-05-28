extends Node2D

class_name Character

# Enum para definir tipos de daño
enum TypeOfDamage {
	PHYSICAL,
	MAGICAL,
	ILLUSORY,
	PIERCING
}

# Propiedades del personaje
var character_name: String
var health: int = 100
var max_health: int = 100
var attack: int = 10
var defense: int = 5
var is_player: bool = true
var is_selected: bool = false
var is_defending: bool = false
var resistance: Array[TypeOfDamage]
var weakness: Array[TypeOfDamage]
var strength: Array[TypeOfDamage]
var additional_turns: int = 0
var additional_turns_pred: int = 0

# Bandera para habilitar la selección de objetivos
var selecting_target: bool = false

# habilidades
var attack_name: String = "Ataque Perforante"
var attack_type: Global.TypeOfHability = Global.TypeOfHability.ATTACK
var hability1_name: String = "habilidad 1"
var hability2_name: String = "habilidad 2"
var hability3_name: String = "habilidad 3"
var hability1_type: Global.TypeOfHability = Global.TypeOfHability.SUPPORT
var hability2_type: Global.TypeOfHability = Global.TypeOfHability.ATTACK
var hability3_type: Global.TypeOfHability = Global.TypeOfHability.ATTACK

@onready var animation_player: AnimationPlayer = $AnimationPlayer
	
func play_animation(animation_name: String) -> void:
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)

# Método para recibir daño
func take_damage(damage: int) -> void:
	health -= damage
	if health < 0:
		health = 0
		
func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health

func calculate_multiplier(typeOfAttack: TypeOfDamage, target: Character) -> float:
	var multiplier: float = 0
	if target.weakness.has(typeOfAttack):
		multiplier += 1.5
	if target.resistance.has(typeOfAttack):
		multiplier += 0.5
	if strength.has(typeOfAttack):
		multiplier += 1.2
		
	return multiplier
	
func calculate_attack(target: Character, multiplier: float):
	var actual_damage = max(0, (attack - target.defense) * multiplier)
	if target.is_defending == true:
		actual_damage = actual_damage/2
	# Reproducir la animación de recibir daño del objetivo
	target.play_animation("hit")
	
	# Aplicar el daño al objetivo
	target.take_damage(int(actual_damage))
	
	# Esperar a que la animación de recibir daño termine
	await target.animation_player.animation_finished

# Método para atacar a otro personaje
func attack_target(target: Character, multiplier: float) -> void:
	# Reproducir la animación de ataque del atacante
	play_animation("attack")
	
	# Esperar a que la animación de ataque termine
	await animation_player.animation_finished
	
	await calculate_attack(target, multiplier)
	

func support_target(target: Character, property, value):
	target[property] += value
	
func hability1(target: Character):
	support_target(target, "additional_turns", 1)
	print(target.additional_turns)
	
func hability2():
	print("2")
	
func hability3():
	print("3")
	

func _ready():
	$Area2D.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	$Area2D.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	$Area2D.connect("input_event", Callable(self, "_on_input_event"))

func _on_mouse_entered():
	if selecting_target:
		_set_highlight(true)

func _on_mouse_exited():
	if selecting_target:
		_set_highlight(false)

func _on_input_event(viewport, event, shape_idx):
	if selecting_target and event is InputEventMouseButton and event.pressed:
		emit_signal("target_selected", self)

func _set_highlight(enabled: bool):
	if enabled:
		$Sprite2D.modulate = Color(1, 1, 1, 0.5)  # Cambia la transparencia o color del sprite para resaltar
		$focus.visible = true
	else:
		$Sprite2D.modulate = Color(1, 1, 1, 1)  # Vuelve al color original
		$focus.visible = false

signal target_selected(character)
