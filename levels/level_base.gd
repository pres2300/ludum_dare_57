extends Node2D

@onready var canvas_modulate = $CanvasModulate
@onready var canvas_modulate_bg = $ParallaxBackground/ParallaxLayer/CanvasModulate
@onready var player = $Player

func _process(_delta: float) -> void:
	canvas_modulate.set_gradient(player.position.y)
	canvas_modulate_bg.set_gradient(player.position.y)
