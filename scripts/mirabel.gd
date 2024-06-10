extends "res://scripts/character.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	character_name = "Mirabel"
	order = 2
	portrait = load("res://graphics/battle/characters/human 1.png")
	
	attack_name = Skills.physical_attack
	attack_description = Skills.physical_attack_description
	attack_type = Skills.physical_attack_type
	
	resistance = [Global.TypeOfDamage.PHYSICAL, Global.TypeOfDamage.PIERCING]
	weakness = [Global.TypeOfDamage.MAGICAL]
	strength = [Global.TypeOfDamage.PHYSICAL]
