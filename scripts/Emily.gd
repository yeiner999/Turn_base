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
	
	hability1_name = Skills.poison_name
	hability1_description = Skills.poison_description
	hability1_core_type = Global.TypeOfHability.DAMAGEPERTURN
	hability1_type = Global.TypeOfDamage.PERTURN
	hability1_damage = Skills.ultra_pierce_attack_damage
	
func hability1(target: Character):
	super.hability1(target)
	Skills.poison(target)
