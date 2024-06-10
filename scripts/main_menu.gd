extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_game_button = $PanelContainer/HBoxContainer/VBoxContainer/Button
	var end_button = $PanelContainer/HBoxContainer/VBoxContainer/Button2
	new_game_button.connect("pressed", Callable(self, "_on_new_game_button_pressed"))
	
func _on_new_game_button_pressed():
	var battle_scene = load("res://scenes/select_battle.tscn")
	
	
	get_tree().change_scene_to_packed(battle_scene)



