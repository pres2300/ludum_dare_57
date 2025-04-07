extends CharacterBody2D

@export var gravity: float = 1000.0
@export var move_speed: float = 400.0
@export var jump_speed: float = -500.0

@export var health: int = 10

@export var has_jetpack: bool = false
@export var has_bag_of_rocks: bool = false
@export var has_knife: bool = false
@export var has_gun: bool = false

@export var rock_scene: PackedScene
@export var bullet_scene: PackedScene

@onready var camera = $Camera2D
@onready var player_sprite = $AnimatedSprite2D

@onready var jetpack_sprite = $JetpackEquipped
@onready var jetpack_exhaust = $JetpackEquipped/CPUParticles2D
@onready var jetpack_sound = $JetpackEquipped/AudioStreamPlayer2D
@onready var jetpack_light = $JetpackEquipped/PointLight2D

@onready var throw_rock_sound = $ThrowRockSound

@onready var knife = $KnifeEquipped
@onready var knife_sprite = $KnifeEquipped/Sprite2D
@onready var knife_sound = $KnifeEquipped/AudioStreamPlayer2D

@onready var gun = $GunEquipped
@onready var muzzle = $GunEquipped/Muzzle
@onready var gun_sound = $GunEquipped/AudioStreamPlayer2D

var attacking: bool = false
var attack_timer = Timer.new()

var i_frames_timer = Timer.new()
var i_frames_timer_count = 2
var can_take_damage = true

const throw_rock_timeout: float = 1.0
const swipe_knife_timeout: float = 0.5
const gun_shoot_timeout: float = 0.1

signal dead

func take_damage():
	if not can_take_damage:
		return

	can_take_damage = false
	health -= 1
	i_frames_timer.start(i_frames_timer_count)

	if health <= 0:
		print("DEAD")
		dead.emit()

func shoot_gun():
	gun_sound.play()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(muzzle.global_transform, player_sprite.flip_h)

func swipe_knife():
	knife_sound.play()
	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if knife_sprite.flip_h:
		tween.tween_property(knife, "position", knife.position - Vector2(35.0, 0), swipe_knife_timeout/2.0).from_current()
	else:
		tween.tween_property(knife, "position", knife.position + Vector2(35.0, 0), swipe_knife_timeout/2.0).from_current()
	tween.tween_property(knife, "position", knife.position, 0.5/2.0)

func throw_rock():
	throw_rock_sound.play()
	var b = rock_scene.instantiate()
	get_tree().root.add_child(b)
	b.position = global_position
	if player_sprite.flip_h:
		b.apply_impulse(Vector2(-750, -100), b.global_position)
	else:
		b.apply_impulse(Vector2(750, -100), b.global_position)

func attack():
	if attacking:
		return

	if has_gun:
		attacking = true
		attack_timer.wait_time = gun_shoot_timeout
		attack_timer.start()
		shoot_gun()
	elif has_knife:
		attacking = true
		attack_timer.wait_time = swipe_knife_timeout
		attack_timer.start()
		swipe_knife()
	elif has_bag_of_rocks:
		attacking = true
		attack_timer.wait_time = throw_rock_timeout
		attack_timer.start()
		throw_rock()

func get_input():
	var right: bool = Input.is_action_pressed("ui_right")
	var left: bool = Input.is_action_pressed("ui_left")
	var jump: bool = Input.is_action_pressed("jump")
	var attack_input: bool = Input.is_action_pressed("attack")

	if attack_input:
		attack()

	velocity.x = 0.0

	if right:
		velocity.x = move_speed
		player_sprite.flip_h = false
		jetpack_sprite.position.x = -21
		knife.position.x = 21
		knife_sprite.flip_h = false
		gun.position.x = 21
		muzzle.position.x = 10
		gun.flip_h = false

	if left:
		velocity.x = -move_speed
		player_sprite.flip_h = true
		jetpack_sprite.position.x = 21
		knife.position.x = -21
		knife_sprite.flip_h = true
		gun.position.x = -21
		muzzle.position.x = -10
		gun.flip_h = true

	if jump and is_on_floor() and not has_jetpack:
		velocity.y = jump_speed
	elif jump and has_jetpack:
		velocity.y = jump_speed
		jetpack_exhaust.emitting = true
		jetpack_light.show()
		if not jetpack_sound.playing:
			jetpack_sound.play()
	elif has_jetpack:
		jetpack_exhaust.emitting = false
		jetpack_light.hide()
		jetpack_sound.stop()

	if is_on_floor():
		if abs(velocity.x) > 0.0:
			player_sprite.play("walk")
		else:
			player_sprite.play("idle")
	else:
		if velocity.y < -0.1:
			player_sprite.play("up")
		elif velocity.y > 0.1:
			player_sprite.play("down")

func equip(item_name: String):
	match item_name:
		"jetpack":
			has_jetpack = true
			jetpack_sprite.show()
		"gun":
			has_gun = true
			has_knife = false
			knife.hide()
			has_bag_of_rocks = false
			gun.show()
		"knife":
			has_knife = true
			has_bag_of_rocks = false
			has_gun = false
			gun.hide()
			knife.show()
		"bag_of_rocks":
			has_bag_of_rocks = true
			has_knife = false
			has_gun = false
		_:
			print("Item not handled in equip!")

func _attack_timer_timeout():
	attacking = false

func _i_frames_timeout():
	can_take_damage = true

func _ready():
	camera.limit_left = 0
	camera.limit_right = get_viewport().get_visible_rect().size.x
	camera.limit_top = 0

	attack_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(attack_timer)
	attack_timer.timeout.connect(_attack_timer_timeout)

	i_frames_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(i_frames_timer)
	i_frames_timer.timeout.connect(_i_frames_timeout)

func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta

	# reset knife position if player moved
	if not attacking and has_knife:
		if player_sprite.flip_h:
			knife.position.x = -21
		else:
			knife.position.x = 21

	get_input()
	move_and_slide()

func _on_knife_equipped_body_entered(body: Node2D) -> void:
	# Only damage if the player is in the attack tween
	if not attacking:
		return

	if body.is_in_group("enemy"):
		body.take_damage()
