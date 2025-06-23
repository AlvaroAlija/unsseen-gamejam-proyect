extends Node

# Este es el índice del nivel actual en level_paths
var current_level := 0

# Lista de rutas a los niveles en orden (el menú es el índice 0)
var level_paths := [
	"res://scenes/main_menu.tscn",  # index 0
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",    
	"res://scenes/level_3.tscn",
	"res://scenes/level_4.tscn",
	"res://scenes/level_5.tscn",
	"res://scenes/level_6.tscn"    
	# Agrega más niveles aquí
]

# Nombre del último nivel jugado, para mostrarlo en la pantalla de fin
var last_level_name := ""

func get_current_level_path() -> String:
	return level_paths[current_level]

func set_current_level_index(index: int):
	current_level = index

func get_last_level_name() -> String:
	return last_level_name

func go_to_next_level():
	current_level += 1
	print("Siguiente nivel:", current_level)

	if current_level < level_paths.size():
		# Guardamos el nombre del nivel anterior
		last_level_name = get_level_name_from_path(level_paths[current_level])
		get_tree().change_scene_to_file(level_paths[current_level])
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		# Aquí podrías ir a créditos u otra pantalla final

# Extrae el nombre del nivel desde el path, por ejemplo:
# "res://scenes/level_1.tscn" -> "level_1"
func get_level_name_from_path(path: String) -> String:
	var file_name = path.get_file().get_basename()
	return file_name
