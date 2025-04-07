extends CharacterBody2D

@export var speed = 300
@export var gravity: float = 1000.0
@export var health: int = 5

@onready var death_sound = $DeathSound
@onready var damage_sound = $DamageSound

var facing = 1
var can_move: bool = false
var target = null

func take_damage():
	health -= 1

	if health == 0:
		death_sound.play()
		await death_sound.finished
		queue_free()
	else:
		damage_sound.play()

func _physics_process(delta):
	velocity.y += gravity*delta

	if can_move and is_instance_valid(target):
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)

			if collision.get_collider().is_in_group("player"):
				collision.get_collider().take_damage()

		velocity.x = (global_position.direction_to(target.get_global_position())*speed).x

	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	target = get_tree().get_first_node_in_group("player")
	can_move = true
