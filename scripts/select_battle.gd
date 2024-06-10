extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var battle1_button = $PanelContainer/HBoxContainer/Button
	var battle2_button = $PanelContainer/HBoxContainer/Button2
	var battle3_button = $PanelContainer/HBoxContainer/Button3
	var battle4_button = $PanelContainer/HBoxContainer/Button4
	var battle5_button = $PanelContainer/HBoxContainer/Button5
	
	battle1_button.connect("pressed", Callable(self, "_on_battle1_button_pressed"))
	
func _on_battle1_button_pressed():
	var battle_scene = load("res://scenes/battle1.tscn")
	
	
	get_tree().change_scene_to_packed(battle_scene)
