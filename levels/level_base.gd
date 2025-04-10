extends Node2D

@onready var canvas_modulate = $CanvasModulate
@onready var canvas_modulate_bg = $ParallaxBackground/ParallaxLayer/CanvasModulate
@onready var player = $Player
@onready var demon = $Demon
@onready var jetpack = $Jetpack
@onready var healthbar = $CanvasLayer/HUD/MarginContainer/TextureProgressBar

signal win
signal lose

func spawn_demon() -> void:
	demon.spawn()

func game_over() -> void:
	lose.emit()

func update_healthbar(player_health) -> void:
	healthbar.value = player_health

func _ready() -> void:
	jetpack.obtained.connect(spawn_demon)
	player.dead.connect(game_over)
	player.damage.connect(update_healthbar)

func _process(_delta: float) -> void:
	canvas_modulate.set_gradient(player.position.y)
	canvas_modulate_bg.set_gradient(player.position.y)

func _on_win_boundary_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		win.emit()
