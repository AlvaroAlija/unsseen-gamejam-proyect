extends Control

@onready var contenedor := $HBoxContainer  # asegúrate de tener un VBoxContainer en la escena

func _ready():
	for i in range(1, GameState.level_paths.size()):  # Empezamos en 1 para saltar el menú
		var path = GameState.level_paths[i]
		var nombre = GameState.get_level_name_from_path(path)
		var datos = GameData.obtener_datos_nivel(nombre)
		var e = datos.get("entregados", 0)
		var t = datos.get("totales", 0)

		var boton = Button.new()
		boton.text = "%s\n%d / %d" % [nombre, e, t]
		boton.name = str(i)  # Guardamos el índice en el nombre
		boton.connect("pressed", _on_level_button_pressed.bind(i))
		contenedor.add_child(boton)

func _on_level_button_pressed(index: int):
	GameState.set_current_level_index(index)
	GameState.last_level_name = GameState.get_level_name_from_path(GameState.level_paths[index])
	get_tree().change_scene_to_file(GameState.level_paths[index])


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
