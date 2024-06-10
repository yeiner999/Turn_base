extends Panel

signal ui_target_selected(character)

var selecting_target = false
var alive = true
var reference_character

func _ready():
	# Habilita la detección de eventos de mouse
	set_mouse_filter(Control.MOUSE_FILTER_PASS)
	connect("mouse_entered",Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

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
		$Panel.visible = true
	else:
		$Panel.visible = false
