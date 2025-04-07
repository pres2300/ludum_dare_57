extends Node

@export var level_scene : PackedScene
@export var win_scene : PackedScene
@export var lose_scene : PackedScene

var level = null
var win_screen = null
var lose_screen = null

func start_game():
	if is_instance_valid(win_screen):
		win_screen.queue_free()

	if is_instance_valid(lose_screen):
		lose_screen.queue_free()

	level = level_scene.instantiate()
	add_child(level)
	level.win.connect(_win)
	level.lose.connect(_lose)

func win_game():
	win_screen = win_scene.instantiate()
	add_child(win_screen)
	win_screen.restart.connect(start_game)

func lose_game():
	lose_screen = lose_scene.instantiate()
	add_child(lose_screen)
	lose_screen.restart.connect(start_game)

func _win():
	level.queue_free()
	call_deferred("win_game")

func _lose():
	level.queue_free()
	call_deferred("lose_game")

func _on_start_button_pressed() -> void:
	$TitleScreen.queue_free()
	$TitleLevel.queue_free()
	call_deferred("start_game")
