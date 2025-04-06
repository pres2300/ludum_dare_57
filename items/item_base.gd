extends Area2D

@export var item_name: String = "not_set"
@export var offset = Vector2(0, -5)
@export var duration = 1.0

@onready var pickup_sound = $PickupSound

func _ready() -> void:
	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($Sprite2D, "position", offset, duration/2.0).from_current()
	tween.tween_property($Sprite2D, "position", Vector2.ZERO, duration/2.0)
	tween.set_trans(Tween.TRANS_SINE)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hide()
		pickup_sound.play()
		body.equip(item_name)
		await pickup_sound.finished
		queue_free()
