extends Node2D

@onready var canvas_modulate = $CanvasModulate
@onready var canvas_modulate_bg = $ParallaxBackground/ParallaxLayer/CanvasModulate
@onready var player = $Player
@onready var demon = $Demon
@onready var jetpack = $Jetpack

func spawn_demon() -> void:
	demon.spawn()

func _ready() -> void:
	jetpack.obtained.connect(spawn_demon)

func _process(_delta: float) -> void:
	canvas_modulate.set_gradient(player.position.y)
	canvas_modulate_bg.set_gradient(player.position.y)
