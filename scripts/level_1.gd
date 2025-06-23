extends Node2D

@export var tiempo_maximo: int = 60
@export var explosivos_totales: int = 2

var explosivos_entregados: int = 0
var tiempo_restante: float

signal nivel_terminado

@onready var tiempo_label := $player/Label

func _ready():
	print("💡 Nodo nivel READY:", self, " ID:", get_instance_id())

	# Reset de estado inicial
	explosivos_entregados = 0
	tiempo_restante = tiempo_maximo
	actualizar_tiempo_label()

	# Detectar y registrar ruta actual del nivel en GameState
	if get_tree().current_scene:
		var current_path = get_tree().current_scene.scene_file_path
		var index = GameState.level_paths.find(current_path)
		if index != -1:
			GameState.set_current_level_index(index)
			GameState.last_level_name = GameState.get_level_name_from_path(current_path)
			print("📌 Nivel actual registrado como:", GameState.last_level_name)

	# Guardar datos iniciales del nivel en GameData
	GameData.guardar_datos_nivel(GameState.last_level_name, explosivos_entregados, explosivos_totales)

func _process(delta: float) -> void:
	
	$player/Label2.text = str(explosivos_entregados) + "/" + str(explosivos_totales)
	
	if tiempo_restante > 0:
		tiempo_restante -= delta
		if tiempo_restante <= 0:
			tiempo_restante = 0
			finalizar_nivel()
	actualizar_tiempo_label()

	if explosivos_entregados >= explosivos_totales and explosivos_totales > 0:
		finalizar_nivel()

func entregar_explosivo():
	explosivos_entregados += 1
	print("🔸 entregar_explosivo desde", self, " ID:", get_instance_id())
	print("entregados:", explosivos_entregados)

func actualizar_tiempo_label():
	if tiempo_label:
		tiempo_label.text = "Time left: %d" % int(tiempo_restante)
	else:
		push_error("¡No encontré el nodo Label en %s!" % self)

func finalizar_nivel():
	set_process(false)

	# Guardar datos finales antes de pasar a fin de nivel
	GameData.guardar_datos_nivel(GameState.last_level_name, explosivos_entregados, explosivos_totales)

	# Instanciar y mostrar pantalla de fin de nivel
	var fin_nivel_scene = preload("res://scenes/fin_nivel.tscn").instantiate()

	# Cambiar escena
	get_tree().get_current_scene().queue_free()
	get_tree().root.add_child(fin_nivel_scene)
	get_tree().set_current_scene(fin_nivel_scene)

	emit_signal("nivel_terminado")
