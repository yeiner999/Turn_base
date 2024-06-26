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

func display_correct_message(target, message):
	if target.is_player:
		await Global.display_damage(message, target.reference_ui.get_node("Marker2D").global_position)
		
	if not target.is_player:
		await Global.display_damage(message, target.get_node("Marker2D").global_position)

#skill poison
func apply_poison_effect(target):
	display_correct_message(target, "Veneno")
	target.get_node("health").visible = true
	target.play_animation("hit")
	target.take_damage(10)
	if target.animation_player.is_playing():
			await target.animation_player.animation_finished
	target.get_node("health").visible = false
	print(target.character_name + " is poisoned! Health is now " + str(target.health))

func remove_poison_effect(target):
	await display_correct_message(target, "Veneno eliminado")
	print(target.character_name + " is no longer poisoned.")
	
func poison(target):
	Global.calculate_multiplier(Global.TypeOfDamage.PIERCING)
	
	Global.current_target = target
	
	var poison_effect_local = effect.new("Poison", 3, 3, Callable(self, "apply_poison_effect"), Callable(self, "remove_poison_effect"))
	emit_signal("reproduce_external_animation", "player_buff")
	target.apply_effect(poison_effect_local)
	
var poison_description = "Envenena al enemigo por 3 turnos"

var poison_damage = 1

var poison_name = "Veneno"

#skill buff turns
func apply_buff_turns_effect(target):
	target.additional_turns += 2
	
	await display_correct_message(target, "+2 Acciones extra")
	
	var duration_local = target.effects
	for effect_local in target.effects:
		if effect_local.effect_name == "buff_turns":
			duration_local = effect_local.duration
			break
			
	print(target.character_name + " is turn buff now for " + str(duration_local) + " turns")

func remove_buff_turns_effect(target):
	await display_correct_message(target, "Acciones extra eliminadas")
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
	
	Global.current_target = target
	
	emit_signal("reproduce_external_animation", "myriad_slashes")
	emit_signal("await_external_animation")
	
var ultra_pierce_attack_description = "Perfora al enemigo muchas veces"

var ultra_pierce_attack_name = "Myriad slashes"

var ultra_pierce_attack_damage = 3
	
	
#skill magic inmunity
func apply_magic_inmunity_effect(target):
	if not target.inmunity.has(Global.TypeOfDamage.MAGICAL):
		target.inmunity.append(Global.TypeOfDamage.MAGICAL)

	var duration_local = 0
	for effect_local in target.effects:
		if effect_local.effect_name == "magic_inmunity":
			duration_local = effect_local.duration
			break
			
	print(target.character_name + " is magic inmune now for " + str(duration_local) + " turns")

func remove_magic_inmunity_effect(target):
	target.inmunity.erase(Global.TypeOfDamage.MAGICAL)
	print(target.character_name + " is no longer magic inmune.")
	

func magic_inmunity(target):
	var magic_inmunity_effect_local = effect.new("magic_inmunity", 3, 3, Callable(self, "apply_magic_inmunity_effect"), Callable(self, "remove_magic_inmunity_effect"))
	emit_signal("reproduce_external_animation", "player_buff")
	target.apply_effect(magic_inmunity_effect_local)
	
	
var magic_inmunity_description = "Otorga inmunidad a la magia por 3 turnos"

var magic_inmunity_name = "Escudo Magico"
	
	
	
	
	
	
	
	
	
	
	
signal reproduce_external_animation(anim)
signal _calculate_damage
signal await_external_animation

