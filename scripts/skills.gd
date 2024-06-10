extends Node


const effect = preload("res://scripts/effects.gd")

#Basic attacks
var pierce_attack = "Ataque perforante"
var pierce_attack_type: Global.TypeOfDamage = Global.TypeOfDamage.PIERCING
var pierce_attack_description = "Ataque perforante"

var physical_attack = "Ataque fisico"
var physical_attack_type: Global.TypeOfDamage = Global.TypeOfDamage.PHYSICAL
var physical_attack_description = "Ataque fisico"

var magic_attack = "Ataque magico"
var magic_attack_type: Global.TypeOfDamage = Global.TypeOfDamage.MAGICAL
var magic_attack_description = "Ataque magico"

var illusory_attack = "Ataque ilusorio"
var illusory_attack_type: Global.TypeOfDamage = Global.TypeOfDamage.ILLUSORY
var illusory_attack_description = "Ataque ilusorio"

#skill poison
func apply_poison_effect(target):
	target.health -= 10
	print(target.character_name + " is poisoned! Health is now " + str(target.health))

func remove_poison_effect(target):
	print(target.character_name + " is no longer poisoned.")
	
var poison_effect = effect.new("Poison", 3, 3, Callable(self, "apply_poison_effect"), Callable(self, "remove_poison_effect"))


#skill buff turns
func apply_buff_turns_effect(target):
	target.additional_turns += 2
	var duration_local = target.effects
	for effect_local in target.effects:
		if effect_local.effect_name == "buff_turns":
			duration_local = effect_local.duration
			break
			
	print(target.character_name + " is turn buff now for " + str(duration_local) + " turns")

func remove_buff_turns_effect(target):
	print(target.character_name + " is no longer buff.")
	
#var buff_turns_effect = effect.new("buff_turns", 3, 3, Callable(self, "apply_buff_turns_effect"), Callable(self, "remove_buff_turns_effect"))

func turn_buff(target):
	var buff_turns_effect_local = effect.new("buff_turns", 3, 3, Callable(self, "apply_buff_turns_effect"), Callable(self, "remove_buff_turns_effect"))
	emit_signal("reproduce_external_animation", "player_buff")
	target.apply_effect(buff_turns_effect_local)
	
var turn_buff_description = "Actua 3 veces por turno por 3 turnos"

var turn_buff_name = "Aceleración"
	
#ultra pierce attack
func ultra_pierce_attack(target):
	Global.calculate_multiplier(Global.TypeOfDamage.PIERCING)
	Global.current_multiplier += 5
	
	Global.current_target = target
	
	emit_signal("reproduce_external_animation", "myriad_slashes")
	emit_signal("await_external_animation")
	
var ultra_pierce_attack_description = "Perfora al enemigo muchas veces"

var ultra_pierce_attack_name = "Myriad slashes"
	
	
	
	
	
	
	
	
	
	
	
	
	
	
signal reproduce_external_animation(anim)
signal _calculate_damage
signal await_external_animation

