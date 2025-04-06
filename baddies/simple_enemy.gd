extends CharacterBody2D

@export var speed = 50
@export var gravity: float = 1000.0

var facing = 1

func take_damage():
	print("enemy take damage")

func _physics_process(delta):
	velocity.y += gravity*delta
	velocity.x = facing*speed

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		if collision.get_collider().name == "Player":
			print("hit player")

		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = -100

	if position.y > 10000:
		queue_free()
