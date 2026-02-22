extends RigidBody3D

@export var camera_move: Vector2 = Vector2(2.0,2.0)
@export_range(1.0,10.0,0.1) var speed: float = 5.0
@export_range(0.5,7.0,0.1) var camera_lerp_speed: float = 3.0
@export var enble_move:bool = true
@export var hold_item: bool = false
@onready var camera: Camera3D = $Camera3D
@export var player_mesh: Node3D
@export var game_over_screen: Control
var _player_sus: float = 0.0
@export_range(0.0, 100.0, 0.01) var player_sus: float:
	get:
		return _player_sus
	set(v):
		if v > _player_sus:
			is_sus = true
			_start_sus_timer()
		_player_sus = v

@export var player_do_sus: bool = false
@export var can_move: bool = true
@export var sus_timeout: float = 2.0
@export var sus_down_per_second: float = 5.0
var camera_original_position: Vector3
var camera_target_offset: Vector3 = Vector3.ZERO
var camera_offset_strength: Vector3
var is_sus: bool = false
var sus_timer: Timer
var anim_player: AnimationPlayer

func _start_sus_timer():
	sus_timer.wait_time = sus_timeout
	sus_timer.start()

func _on_sus_timeout():
	is_sus = false

func _ready() -> void:
	lock_rotation = true    # alternativně přes inspector
	camera_original_position = camera.position
	camera_offset_strength = Vector3(camera_move.x, 0.0, camera_move.y)
	player_mesh = $PlayerNode

	sus_timer = Timer.new()
	sus_timer.wait_time = sus_timeout
	sus_timer.one_shot = true
	sus_timer.timeout.connect(_on_sus_timeout)
	add_child(sus_timer)

	anim_player = player_mesh.get_node("AnimationPlayer")

func _physics_process(delta):
	if can_move:
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		if input_dir:
			input_dir = input_dir.rotated(PI / 4)
			# RigidBody: nastavit linear_velocity přímo
			linear_velocity.x = input_dir.x * speed
			linear_velocity.z = input_dir.y * speed
			camera_target_offset = Vector3(-input_dir.x, 0.0, -input_dir.y) * camera_offset_strength
			player_mesh.global_rotation.y = Vector2(input_dir.x, -input_dir.y).angle() + PI / 2

			if hold_item:
				anim_player.play("run_item")
			else:
				anim_player.play("run")
		else:
			# zachovat Y velocity (gravitace), vyhasit jen X a Z
			linear_velocity.x = move_toward(linear_velocity.x, 0, speed)
			linear_velocity.z = move_toward(linear_velocity.z, 0, speed)
			camera_target_offset = Vector3.ZERO

			if hold_item:
				anim_player.play("t_pose")
			else:
				anim_player.play("idle")

		camera.position = camera.position.lerp(camera_original_position + camera_target_offset, camera_lerp_speed * delta)

		if player_sus >= 100.0:
			can_move = false
			Engine.time_scale = 0.0
			game_over_screen.visible = true
			print("game over")
		if player_sus > 0.0 and !is_sus:
			player_sus -= sus_down_per_second * delta
			if player_sus < 0.0:
				player_sus = 0.0

func _get_mouse_world_position() -> Variant:
	var cam = get_viewport().get_camera_3d()
	if not cam:
		return null
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = cam.project_ray_origin(mouse_pos)
	var ray_dir = cam.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, global_position.y)
	return plane.intersects_ray(ray_origin, ray_dir)
