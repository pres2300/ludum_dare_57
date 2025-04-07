extends CharacterBody2D

@export var fast_move_speed : int = 300
@export var slow_move_speed : int = 100
@export var slow_time : int = 2 # seconds

var move_speed = fast_move_speed

var can_move: bool = false
var target = null

var slow_timer = Timer.new()

func take_damage():
	move_speed = slow_move_speed
	slow_timer.start(slow_time)

func spawn():
	# The demon already exists, but this gets it moving and chasing
	target = get_tree().get_first_node_in_group("player")
	can_move = true

func _slow_timer_timeout():
	move_speed = fast_move_speed

func _ready():
	slow_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(slow_timer)
	slow_timer.timeout.connect(_slow_timer_timeout)

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
