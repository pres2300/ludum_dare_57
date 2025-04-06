extends RigidBody2D

var has_damaged: bool = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _physics_process(_delta):
	# only damage once
	if not has_damaged:
		for i in get_colliding_bodies():
			if i.is_in_group("enemy"):
				i.take_damage()
				has_damaged = true
