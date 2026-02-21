extends Control

@export var code:int = 123456
@export_color_no_alpha var wrong_color: Color = Color("d30000")
@export_color_no_alpha var warn_color: Color = Color("d4b700")
@export var player: CharacterBody3D
var UI_element: Control

signal open_door

var index_number: int = 0
var display_text: String = "- - - - - -"
var user_code = 0
var display_text_node: Label
var player_inside: bool = false

var first_run= true

func _ready():
	await get_tree().process_frame
	display_text_node = $MarginContainer/MarginContainer/AspectRatioContainer/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/DisplayText
	UI_element = %TakeKey

func _process(delta: float) -> void:
	if first_run:
		UI_element.visible = false
		player_inside = false

func _set_display_text_node_text():
	display_text_node.text = display_text
	
func _set_number_text(num: String):
	if index_number< 12:
		index_number += 2
		if index_number == 2:
			display_text = num + " " + display_text.substr(index_number)
		else: 
			if index_number == 12:
				display_text = display_text.substr(0, index_number-2) + num
				_text_to_code()
			else:
				display_text = display_text.substr(0, index_number-2) + num + " " + display_text.substr(index_number)
		_set_display_text_node_text()
	else:
		_change_text_color(warn_color, 1)

func _text_to_code():
	var to_parse = display_text
	to_parse = to_parse.replace(" ", "")
	user_code = int(to_parse)

func _change_text_color(col: Color, time:int):
	var original_color = display_text_node.get_theme_color("font_color")
	display_text_node.add_theme_color_override("font_color", col)
	
	var tween = create_tween()
	tween.tween_method(
		func(c: Color): display_text_node.add_theme_color_override("font_color", c),
		col,
		original_color,
		time
	)
	
func _close():
	visible = false
	player.can_move = true

func _on_button_1_pressed() -> void:
	_set_number_text("1")

func _on_button_2_pressed() -> void:
	_set_number_text("2")

func _on_button_3_pressed() -> void:
	_set_number_text("3")

func _on_button_4_pressed() -> void:
	_set_number_text("4")

func _on_button_5_pressed() -> void:
	_set_number_text("5")

func _on_button_6_pressed() -> void:
	_set_number_text("6")

func _on_button_7_pressed() -> void:
	_set_number_text("7")

func _on_button_8_pressed() -> void:
	_set_number_text("8")

func _on_button_9_pressed() -> void:
	_set_number_text("9")

func _on_button_cancel_pressed() -> void:
	index_number = 0
	user_code = 0
	display_text = "- - - - - -"
	_set_display_text_node_text()

func _on_button_0_pressed() -> void:
	_set_number_text("0")

func _on_button_ok_pressed() -> void:
	if code != user_code:
		_change_text_color(wrong_color, 2)
		index_number = 0
		display_text = "- - - - - -"
		_set_display_text_node_text()
	else:
		_close()
		open_door.emit()

func _on_area_3d_body_entered(body: Node3D) -> void:
	player_inside = true
	UI_element.visible = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	player_inside = false
	UI_element.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button") or event.is_action_pressed("move_backward") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("space"):
			first_run = false
	if player_inside:
		if event.is_action_pressed("action_button"):
			visible = !visible
			player.can_move = !player.can_moveaaa

func _on_close_button_pressed() -> void:
	_close()
