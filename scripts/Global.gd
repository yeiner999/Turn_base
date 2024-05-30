extends Node

var game_over_message

# Enum para definir tipos de daño
enum TypeOfDamage {
	PHYSICAL,
	MAGICAL,
	ILLUSORY,
	PIERCING
}

enum TypeOfHability {
	ATTACK,
	SUPPORT
}

var current_attacker: Character
var current_target: Character
var current_multiplier = 3

func calculate_multiplier(typeOfAttack: TypeOfDamage) -> void:
	var multiplier: float = 0
	if current_target.weakness.has(typeOfAttack):
		multiplier += 1.5
	if current_target.resistance.has(typeOfAttack):
		multiplier += 0.5
	if current_attacker.strength.has(typeOfAttack):
		multiplier += 1.2
	
	current_multiplier = multiplier
