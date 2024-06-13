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
	hability2_damage = Skills.ultra_pierce_attack_damage
	
	hability3_name = Skills.magic_inmunity_name
	hability3_description = Skills.magic_inmunity_description
	hability3_core_type = Global.TypeOfHability.SUPPORT
	hability3_type = Global.TypeOfDamage.NONE
	
func hability1(target: Character):
	super.hability1(target)
	Skills.turn_buff(target)
	
func hability2(target: Character):
	super.hability2(target)
	Skills.ultra_pierce_attack(target)
	
func hability3(target: Character):
	super.hability3(target)
	Skills.magic_inmunity(target)
