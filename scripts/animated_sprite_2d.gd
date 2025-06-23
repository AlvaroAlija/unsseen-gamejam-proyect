extends CharacterBody2D

@export var move_speed: float = 10



var on_area = false

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = sign(mouse_pos - global_position)

	if on_area:
		global_position += direction * move_speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	on_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	on_area = false
