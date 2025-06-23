extends Sprite2D

var texto: String = ""
var index := 0

func _ready():
	$Label.text = ""
	visible = false

func mostrar_texto(nuevo_texto: String) -> void:
	if nuevo_texto.is_empty():
		return

	texto = nuevo_texto
	index = 0
	$Label.text = ""
	visible = true
	$Timer.start()






func _on_timer_timeout() -> void:
	if index >= texto.length():
		$Timer.stop()
		$TimerB.start()
	else:
		$Label.text += texto[index]
		index += 1



func _on_timer_b_timeout() -> void:
	visible = false
