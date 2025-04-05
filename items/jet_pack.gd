extends Area2D

@export var item_name: String = "jetpack"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.equip_jetpack()
		queue_free()
