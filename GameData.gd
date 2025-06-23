extends Node

var cinematica = false

var niveles = {}

func guardar_datos_nivel(nombre_nivel: String, entregados: int, totales: int):
	niveles[nombre_nivel] = {
		"entregados": entregados,
		"totales": totales
	}

func obtener_datos_nivel(nombre_nivel: String) -> Dictionary:
	return niveles.get(nombre_nivel, {"entregados": 0, "totales": 0})
