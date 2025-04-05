extends CharacterBody2D

@export var gravity: float = 1000.0
@export var move_speed: float = 400.0
@export var jump_speed: float = -500.0
@export var has_jetpack: bool = false

@onready var camera = $Camera2D

func get_input():
	var right: bool = Input.is_action_pressed("ui_right")
	var left: bool = Input.is_action_pressed("ui_left")
	var jump: bool = Input.is_action_pressed("jump")

	velocity.x = 0.0

	if right:
		velocity.x = move_speed

	if left:
		velocity.x = -move_speed

	if jump and is_on_floor() and not has_jetpack:
		velocity.y = jump_speed
	elif jump and has_jetpack:
		velocity.y = jump_speed

func equip_jetpack():
	has_jetpack = true

func _ready():
	camera.limit_left = 0
	camera.limit_right = get_viewport().get_visible_rect().size.x
	camera.limit_top = 0
	#camera.limit_bottom = get_viewport().get_visible_rect().size.y

func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta

	get_input()
	move_and_slide()
