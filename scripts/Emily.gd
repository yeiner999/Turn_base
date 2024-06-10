extends "res://scripts/character.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	character_name = "Emily"
	order = 1
	portrait = load("res://graphics/battle/characters/human 3.png")
	
	attack_name = Skills.magic_attack
	attack_description = Skills.magic_attack_description
	attack_type = Skills.magic_attack_type
	
	resistance = [Global.TypeOfDamage.MAGICAL, Global.TypeOfDamage.ILLUSORY]
	weakness = [Global.TypeOfDamage.PIERCING]
	strength = [Global.TypeOfDamage.ILLUSORY]
