extends RigidBody2D

var is_held: bool = false

func set_held(value: bool) -> void:
	is_held = value
	$CollisionShape2D.disabled = value
