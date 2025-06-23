extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = 400.0
@export var gravity: float = 1200.0

@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0

@export var flash_duration: float = 0.5
@export var flash_cooldown: float = 4.0

@export var explosive_hold_point: NodePath
@onready var camera = $Camera2D
@onready var camera_anchor = $CameraAnchor
@onready var camera_zoom_def = Vector2(1, 1)
@onready var camera_less_zoom = Vector2(0.8, 0.8)

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var run_particles: CPUParticles2D = $RunParticles
@onready var dash_particles: CPUParticles2D = $CPUParticles2D

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: int = 1  # 1 = derecha, -1 = izquierda

var flash_timer: float = 0.0
var flash_on_cooldown: bool = false

var held_explosive: RigidBody2D = null
var nearby_explosive: RigidBody2D = null

# === Coyote Time ===
@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0
var was_on_floor: bool = false

func _ready():
	pass

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("R"):
		get_tree().reload_current_scene()

	# === Coyote Time update ===
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	was_on_floor = is_on_floor()

	if not is_on_floor():
		anim_sprite.play("jump")

	if is_dashing:
		handle_dash_movement()
	else:
		handle_movement()
		apply_gravity(delta)

		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
			start_dash()

	dash_timer -= delta
	if dash_timer <= 0 and is_dashing:
		end_dash()

	dash_cooldown_timer = max(dash_cooldown_timer - delta, 0)

	if held_explosive:
		held_explosive.global_position = get_node(explosive_hold_point).global_position

	move_and_slide()

func handle_movement() -> void:
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * move_speed

	if input_direction != 0:
		dash_direction = sign(input_direction)
		anim_sprite.flip_h = input_direction < 0
		if is_on_floor():
			anim_sprite.play("run")
			run_particles.emitting = true
			run_particles.scale.x = -1 if input_direction < 0 else 1  # Invierte dirección
	else:
		if is_on_floor():
			anim_sprite.play("idle")
		run_particles.emitting = false

	# === Usar coyote_time para permitir saltar tras caer ===
	if (is_on_floor() or coyote_timer > 0.0) and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force
		anim_sprite.play("jump")
		coyote_timer = 0.0

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		run_particles.emitting = false

	if not is_on_floor():
		velocity.y += gravity * delta
		anim_sprite.play("jump")
	elif velocity.y > 0:
		velocity.y = 0

func start_dash() -> void:
	is_dashing = true
	dash_timer = dash_duration
	dash_cooldown_timer = dash_cooldown
	velocity.x = dash_direction * dash_speed
	velocity.y = 0
	dash_particles.emitting = true
	dash_particles.scale.x = -1 if dash_direction < 0 else 1
	
	# === Camera Shake ===
	shake_camera()

func handle_dash_movement() -> void:
	velocity.x = dash_direction * dash_speed
	velocity.y = 0
	anim_sprite.flip_h = dash_direction < 0	
	anim_sprite.play("dash")

func end_dash() -> void:
	is_dashing = false
	dash_particles.emitting = false
	# Reset cámara a la posición del anchor
	camera.position = camera_anchor.position

func _process(delta: float) -> void:
	handle_flash_input()
	handle_explosive_toggle()

func handle_flash_input() -> void:
	if Input.is_action_just_pressed("flash") and not flash_on_cooldown:
		trigger_flash()

func trigger_flash() -> void:
	camera.zoom = camera_less_zoom
	$PointLight2D_Flash.visible = true
	await get_tree().create_timer(flash_duration).timeout
	$PointLight2D_Flash.visible = false
	flash_on_cooldown = true
	camera.zoom = camera_zoom_def
	await get_tree().create_timer(flash_cooldown).timeout
	flash_on_cooldown = false
	camera.zoom = camera_zoom_def

func handle_explosive_toggle() -> void:
	if Input.is_action_just_pressed("interact"):
		if held_explosive:
			release_explosive()
		elif nearby_explosive:
			held_explosive = nearby_explosive
			held_explosive.freeze = true
			held_explosive.linear_velocity = Vector2.ZERO
			held_explosive.angular_velocity = 0
			held_explosive.set_held(true)

func release_explosive():
	if not held_explosive:
		return

	held_explosive.freeze = false
	held_explosive.global_position = get_node(explosive_hold_point).global_position
	var throw_force = 600
	held_explosive.linear_velocity = Vector2(dash_direction * throw_force, -100)
	held_explosive.set_held(false)
	held_explosive = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("explosives") and nearby_explosive == null:
		nearby_explosive = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == nearby_explosive:
		nearby_explosive = null

# === Función simple para Camera Shake ===
func shake_camera():
	var shake_amount = 1
	var shake_time = 0.35
	var timer = 0.0

	while timer < shake_time:
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		camera.position = offset
		await get_tree().process_frame
		timer += get_process_delta_time()

	camera.position = camera_anchor.position
