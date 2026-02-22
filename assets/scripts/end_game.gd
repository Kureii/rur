extends MeshInstance3D
@onready var player: RigidBody3D = %Player
@onready var UI_element: Control = %TakeKey

var is_player_inside = false

var first_run = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button") or event.is_action_pressed("move_backward") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("space"):
		first_run = false
	if is_player_inside:
		if event.is_action_pressed("action_button"):
			get_tree().change_scene_to_file("res://assets/core_scenes/epilog.tscn")

func _process(delta: float) -> void:
	if first_run:
		UI_element.visible = false
		is_player_inside = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	UI_element.visible = true
	is_player_inside = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	UI_element.visible = false
	is_player_inside = false
