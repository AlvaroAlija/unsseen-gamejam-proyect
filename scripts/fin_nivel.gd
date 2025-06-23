extends Control

func _ready() -> void:
	var scene_name = GameState.get_last_level_name()
	var datos = GameData.obtener_datos_nivel(scene_name)
	var e = datos.get("entregados", 0)
	var t = datos.get("totales", 0)
	$Label.text = "%d / %d" % [e, t]
	print("► Leyendo nivel %s -> %s" % [scene_name, datos])

func _on_button_pressed() -> void:
	# En lugar de ir al siguiente nivel, vamos al selector
	get_tree().change_scene_to_file("res://scenes/selector_niveles.tscn")
