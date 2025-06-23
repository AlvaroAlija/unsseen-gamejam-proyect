extends Control


func _on_button_pressed() -> void:
	if GameData.cinematica:
		get_tree().change_scene_to_file("res://scenes/selector_niveles.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/cinematica.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
