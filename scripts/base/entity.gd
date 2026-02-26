extends CharacterBody3D

const SPEED: float = 10.0
var gravity: Variant = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity: float = 0.002
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		# Rotate body horizontally
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Rotate camera vertically
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		# Clamp camera
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta) -> void:
	# Gravity handling
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Walk handling
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
