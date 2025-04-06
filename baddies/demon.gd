extends CharacterBody2D

@export var move_speed : int = 300

var can_move: bool = false
var target = null

func take_damage():
	print("demon take damage")

func spawn():
	# The demon already exists, but this gets it moving and chasing
	target = get_tree().get_first_node_in_group("player")
	can_move = true

func _physics_process(_delta):
	if can_move and is_instance_valid(target):
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)

			if collision.get_collider().is_in_group("Player") and collision.get_collider().can_take_damage():
				collision.get_collider().take_damage(5)
				velocity = Vector2.ZERO
				#global_position = global_position+(collision.get_normal()*bounce_distance)
				#bounce_back = true

		velocity = global_position.direction_to(target.get_global_position())*move_speed
		move_and_slide()
