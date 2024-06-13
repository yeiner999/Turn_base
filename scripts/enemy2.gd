extends "res://scripts/character.gd"

func _ready():
	is_player = false
	character_name = "enemy2"
	health = 200
	max_health = 200
	attack = 10
	order = 1
	additional_turns = 0
	additional_turns_pred = 0
	
	attack_name = Skills.magic_attack
	attack_description = Skills.magic_attack_description
	attack_type = Skills.magic_attack_type
	
	resistance = [Global.TypeOfDamage.MAGICAL]
	weakness = [Global.TypeOfDamage.PHYSICAL]
	strength = [Global.TypeOfDamage.MAGICAL]
	super._ready()
	# Invertir el sprite para que mire hacia la izquierda
	#$Sprite2D.texture = spr_1
	#$Area2D/CollisionShape2D.scale = Vector2(40, 40)
	
func hability2(target: Character):
	super.hability2(target)
	target.apply_effect(Skills.poison_effect)
