extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("explosives"):
		print("explosivo entregado")
		get_tree().current_scene.entregar_explosivo()
		body.queue_free()
