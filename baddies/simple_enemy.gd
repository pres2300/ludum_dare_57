extends CharacterBody2D

@export var speed = 200
@export var gravity: float = 1000.0
@export var health: int = 3

@onready var death_sound = $DeathSound
@onready var damage_sound = $DamageSound

var facing = 1

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
	velocity.x = facing*speed

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		if collision.get_collider().is_in_group("player"):
			collision.get_collider().take_damage()

		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = -100
