extends MeshInstance3D

@export var ID: int = 1
@export var UI_element: Control
@export var player: CharacterBody3D
@export var offset: Vector3 = Vector3(0.0,1.0,-0.5)
@export var world_node: Node3D
@export var emplace_node: Node3D
@export var emplace_offset: Vector3 = Vector3(0.0,0.5,0.0)

var is_player_inside = false
var is_player_holding = false
var is_emplace_near = false
var first_run = true
var parent_node: Node3D

func _input(event: InputEvent) -> void:
	if is_player_inside:
		if event.is_action_pressed("action_button"):
			parent_node = get_parent_node_3d()
			if parent_node == player:
				if is_emplace_near:
					reparent(emplace_node)
					position = emplace_offset
				else:
					var position_tmp = global_position
					var rotation_tmp = global_rotation
					reparent(world_node)
					position = Vector3(position_tmp.x, position_tmp.y - offset.y, position_tmp.z)
					rotation = rotation_tmp
				is_player_holding = false
				player.player_do_sus = false
			if parent_node == world_node:
				is_player_holding = true
				reparent(player)
				position = offset
				player.player_do_sus = true
			show_ui_element()
			parent_node = get_parent_node_3d()

func _process(delta: float) -> void:
	if first_run:
		first_run = false
		is_player_inside = false
		is_player_holding = false
		is_emplace_near = false
	if parent_node == player:
		var rot_y = player.player_mesh.rotation.y
		rotation.y = rot_y
		position = offset.rotated(Vector3.UP, rot_y)
	player.hold_item = is_player_holding

func show_ui_element():
	if parent_node != emplace_node:
		UI_element.visible = is_player_inside && (!is_player_holding || is_emplace_near)

func _on_player_entered(body: Node3D) -> void:
	is_player_inside = true
	show_ui_element()

func _on_player_exited(body: Node3D) -> void:
	is_player_inside = false
	show_ui_element()

func _on_emplace_entered(body: Node3D) -> void:
	is_emplace_near = true
	show_ui_element()

func _on_emplace_exited(body: Node3D) -> void:
	is_emplace_near = false
	show_ui_element()
