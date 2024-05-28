extends Control

# Radio del semicírculo
@export var radius: float = 200.0

func _ready():
	# Obtener la cantidad de botones
	var button_count = get_child_count()
	# El ángulo de separación entre cada botón
	var angle_step = PI / (button_count - 1)

	# Posicionar cada botón
	for i in range(button_count):
		var button = get_child(i)
		var angle = angle_step * i - 2 * PI / 2 # Empezar desde 0 grados hasta PI
		var x = radius * cos(angle) 
		var y = radius * sin(angle)
		button.position = Vector2(x, y)
