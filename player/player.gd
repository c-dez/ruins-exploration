extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var mesh: MeshInstance3D = get_node("MeshInstance3D")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

	mesh.global_rotation.y = lerp_angle(mesh.global_rotation.y ,target_angle, speed * delta)
	pass