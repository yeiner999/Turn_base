extends Panel

signal ui_target_selected(character)

@onready var ui_selected = $Panel
@onready var target_indicator = $Panel2

var selecting_target = false
var alive = true
var reference_character

func _ready():
	# Habilita la detección de eventos de mouse
	set_mouse_filter(Control.MOUSE_FILTER_PASS)
	connect("mouse_entered",Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _process(_delta):
	if Global.current_target == reference_character and not Global.current_attacker.is_player:
		target_indicator.visible = true
	else:
		target_indicator.visible = false

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and selecting_target:
		emit_signal("ui_target_selected", reference_character)
		
func _on_mouse_entered():
	if selecting_target:
		_set_highlight(true)

func _on_mouse_exited():
	if selecting_target:
		_set_highlight(false)

func _set_highlight(enabled: bool):
	if enabled:
		ui_selected.visible = true
	else:
		ui_selected.visible = false
