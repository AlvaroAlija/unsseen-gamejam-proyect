extends Node2D

@onready var player_reference = $"../player/Node2D2"


func _process(delta: float) -> void:
	global_position = player_reference.global_position
