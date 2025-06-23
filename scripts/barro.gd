extends Area2D

var in_barro = false
var player

var out_barro = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		in_barro = true
		
func _process(delta: float) -> void:
	if in_barro:
		player.move_speed = 100
	if out_barro and not in_barro:
		player.move_speed = 200


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		out_barro = true
		in_barro = false
