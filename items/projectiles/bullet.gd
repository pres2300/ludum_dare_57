extends Area2D

@export var speed = 1000

var velocity = Vector2.ZERO
var damage = 5

func start(_transform, flip_h):
	# Only get the origin and rotation of the _transform to avoid scale issues
	position = _transform.get_origin()
	if flip_h:
		rotation = _transform.get_rotation()-PI
	else:
		rotation = _transform.get_rotation()
	velocity = (transform.x/transform.get_scale().x)*speed

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _process(delta):
	position += velocity*delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
