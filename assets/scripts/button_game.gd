extends Control

var game_state: Array[bool] = [false, false, true, false]

@export_color_no_alpha var on_color: Color = Color("008700")
@export_color_no_alpha var off_color: Color = Color("483c42")

@onready var visual_button_01: ColorRect = $MarginContainer/ColorRect2/MarginContainer/HBoxContainer/VisualButton01
@onready var visual_button_02: ColorRect = $MarginContainer/ColorRect2/MarginContainer/HBoxContainer/VisualButton02
@onready var visual_button_03: ColorRect = $MarginContainer/ColorRect2/MarginContainer/HBoxContainer/VisualButton03
@onready var visual_button_04: ColorRect = $MarginContainer/ColorRect2/MarginContainer/HBoxContainer/VisualButton04

func _set_buttons():
	visual_button_01.color = on_color if game_state[0] else off_color
	visual_button_02.color = on_color if game_state[1] else off_color
	visual_button_03.color = on_color if game_state[2] else off_color
	visual_button_04.color = on_color if game_state[3] else off_color
	_check_state()

func _on_button_01_pressed() -> void:
	game_state[0] = !game_state[0]
	game_state[1] = !game_state[1]
	_set_buttons()

func _on_button_02_pressed() -> void:
	game_state[0] = !game_state[0]
	game_state[1] = !game_state[1]
	game_state[2] = !game_state[2]
	_set_buttons()

func _on_button_03_pressed() -> void:
	game_state[1] = !game_state[1]
	game_state[2] = !game_state[2]
	game_state[3] = !game_state[3]
	_set_buttons()

func _on_button_04_pressed() -> void:
	game_state[2] = !game_state[2]
	game_state[3] = !game_state[3]
	_set_buttons()
	
func _check_state():
	var win = game_state[0] && game_state[1] && game_state[2] && game_state[3]
	if win:
		print("win")
	
