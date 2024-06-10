extends "res://scripts/character.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	character_name = "Hector"
	order = 0
	portrait = load("res://graphics/battle/characters/Legendary Warrior.png")
	
	attack_name = Skills.pierce_attack
	attack_description = Skills.pierce_attack_description
	attack_type = Skills.pierce_attack_type
	
	resistance = [Global.TypeOfDamage.MAGICAL, Global.TypeOfDamage.PHYSICAL]
	weakness = [Global.TypeOfDamage.ILLUSORY]
	strength = [Global.TypeOfDamage.PIERCING]
	
	hability1_name = Skills.turn_buff_name
	hability1_description = Skills.turn_buff_description
	hability1_core_type = Global.TypeOfHability.SUPPORT
	hability1_type = Global.TypeOfDamage.NONE
	
	hability2_name = Skills.ultra_pierce_attack_name
	hability2_description = Skills.ultra_pierce_attack_description
	hability2_core_type = Global.TypeOfHability.ATTACK
	hability2_type = Global.TypeOfDamage.PIERCING
	
func hability1(target: Character):
	Skills.turn_buff(target)
	
func hability2(target: Character):
	Skills.ultra_pierce_attack(target)
