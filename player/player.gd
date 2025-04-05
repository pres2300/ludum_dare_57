extends CharacterBody2D

@export var gravity: float = 750.0
@export var move_speed: float = 200.0

@onready var camera = $Camera2D

func get_input():
	var right: bool = Input.is_action_pressed("ui_right")
	var left:bool = Input.is_action_pressed("ui_left")

	velocity.x = 0.0

	if right:
		velocity.x = move_speed

	if left:
		velocity.x = -move_speed

func _ready():
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_bottom = get_viewport().get_visible_rect().size.y
	camera.limit_right = get_viewport().get_visible_rect().size.x

func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta

	get_input()
	move_and_slide()
