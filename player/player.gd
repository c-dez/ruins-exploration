extends CharacterBody3D


const SPEED = 8
const JUMP_VELOCITY = 5
@onready var mesh: MeshInstance3D = get_node("MeshInstance3D")

# jump
@export var jump_height: float = 2.5
@export var jump_time_peak: float = 0.5
@export var jump_time_descend: float = 0.4
var _jump_velocity: float
var _jump_gravity: float
var _jump_fall_gravity: float


func _ready() -> void:
	calculate_jump_gravity()


func _physics_process(delta: float) -> void:
	gravity(delta)
	jump()
	move(delta)


func gravity(delta) -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			velocity.y -= _jump_fall_gravity * delta
		else:
			velocity.y -= _jump_gravity * delta


func jump() -> void:
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = _jump_velocity


func move(delta) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		rotate_mesh(-direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

## Rotates the mesh to the move direction
func rotate_mesh(direction: Vector3, delta: float, speed: float = 12) -> void:
	var las_move_direction
	# se asegura de seguir mirando a la ultima direccion si no hay direccion
	if direction.length() > 0:
		las_move_direction = direction
	else:
		las_move_direction = Vector3.FORWARD

	var target_angle := Vector3.BACK.signed_angle_to(las_move_direction, Vector3.UP)

	mesh.global_rotation.y = lerp_angle(mesh.global_rotation.y, target_angle, speed * delta)
	pass


func calculate_jump_gravity() -> void:
	_jump_velocity = 2.0 * jump_height / jump_time_peak
	_jump_gravity = 2.0 * jump_height / (jump_time_peak * jump_time_peak)
	_jump_fall_gravity = 2.0 * jump_height / (jump_time_descend * jump_time_descend)