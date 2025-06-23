extends Control

@onready var volume_slider = $VBoxContainer/HSlider

func _ready():
	# Carga el valor guardado o usa 0 por defecto
	var saved_volume = ProjectSettings.get_setting("user_settings/master_volume", 0.0)
	volume_slider.value = saved_volume
	_set_volume(saved_volume)

	volume_slider.connect("value_changed", _on_volume_changed)

func _on_volume_changed(value: float) -> void:
	_set_volume(value)
	# Guarda en las opciones del proyecto para persistencia
	ProjectSettings.set_setting("user_settings/master_volume", value)
	ProjectSettings.save()

func _set_volume(value: float) -> void:
	# Asume que el bus 'Master' es el primero (index 0)
	AudioServer.set_bus_volume_db(0, value)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
