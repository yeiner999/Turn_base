extends "res://scripts/character.gd"

func _ready():
	super._ready()
	health = 200
	max_health = 200
	attack = 10
	additional_turns = 1
	additional_turns_pred = 1
	resistance = [Global.TypeOfDamage.MAGICAL]
	weakness = [Global.TypeOfDamage.PHYSICAL]
	strength = [Global.TypeOfDamage.MAGICAL]
	attack_type = Global.TypeOfDamage.MAGICAL
	# Invertir el sprite para que mire hacia la izquierda
	#$Sprite2D.texture = spr_1
	#$Area2D/CollisionShape2D.scale = Vector2(40, 40)
