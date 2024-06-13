extends Node

var game_over_message

# Enum para definir tipos de daño
enum TypeOfDamage {
	PHYSICAL,
	MAGICAL,
	ILLUSORY,
	PIERCING,
	NONE
}

enum TypeOfHability {
	ATTACK,
	SUPPORT
}

enum CharaState {
	ALIVE,
	DEFENDING,
	DEATH
}

enum CurrentAttack {
	ATTACK,
	SKILL1,
	SKILL2,
	SKILL3
}

var current_attacker: Character
var current_target: Character
var current_multiplier = 1

func await_current_target_animation() -> void:
	if Global.current_target:
		if Global.current_target.animation_player.is_playing():
			await Global.current_target.animation_player.animation_finished

func calculate_multiplier(typeOfAttack: TypeOfDamage) -> void:
	var multiplier: float = 1
	if current_target.weakness.has(typeOfAttack):
		multiplier += 1.5
	if current_target.resistance.has(typeOfAttack):
		multiplier -= 0.5
	if current_attacker.strength.has(typeOfAttack):
		multiplier += 1.2
	if current_target.inmunity.has(typeOfAttack):
		multiplier = 0
	
	current_multiplier = multiplier
	
func display_damage(damage, position):
	var label = Label.new()
	label.global_position = position
	label.text = damage
	label.z_index = 11
	label.label_settings = LabelSettings.new()
	
	var color = Color.CORNSILK
	
	#label.anchors_preset = "PresetCenter"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.label_settings.font_color = color
	label.label_settings.font_size = 70
	label.label_settings.outline_color = Color.BLACK
	label.label_settings.outline_size = 10
	
	call_deferred("add_child", label)
	
	await label.resized
	label.pivot_offset = (label.size/2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		label, "position:y", label.position.y - 24, 0.25
	). set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		label, "position:y", label.position.y, 0.5
	). set_ease(Tween.EASE_IN). set_delay(0.25)
	
	tween.tween_property(
		label, "scale", Vector2.ZERO, 0.25
	). set_ease(Tween.EASE_IN). set_delay(0.5)
	
	await tween.finished
	label.queue_free()
