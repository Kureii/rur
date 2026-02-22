extends Control

@export var code_node: Control
@onready var player: RigidBody3D = %Player

@export var sus_per_second: float = 5.0
@onready var UI_element: Control = %TakeKey

var text1: RichTextLabel
var is_player_inside: bool = false


var first_run = true

func _ready():
	
	text1 = $MarginContainer/MarginContainer/AspectRatioContainer/MarginContainer/Text1
	var code = randi_range(100000, 999999)
	code_node.code = code
	var digits = str(code)
	
	var my_text1 = """From: Boss

To: Employee n. 33

Subject: Termination of Employment

Dear Employee number #{0}{1}{2}{3}{4}{5},
I am writing to inform you that your employment is being terminated, effective immediately. To be honest, your efficiency is becoming a problem for our low standards.
We have decided to replace you with a significantly cheaper workforce that doesn't work nearly as well. Please pack your things and exit the building."""

	var result_text1 = my_text1.format({
		"0": digits[0],
		"1": digits[1],
		"2": digits[2],
		"3": digits[3],
		"4": digits[4],
		"5": digits[5],
	})
	
	text1.text = result_text1

func _process(delta: float) -> void:
	if first_run:
		UI_element.visible = false
		is_player_inside = false
	if player.player_do_sus:
		player.player_sus += sus_per_second * delta

func _on_close_button_pressed() -> void:
	visible = false
	player.player_do_sus = false
	player.can_move = true


func _on_code_document_body_entered(body: Node3D) -> void:
	print("enter")
	UI_element.visible = true
	is_player_inside = true


func _on_code_document_body_exited(body: Node3D) -> void:
	UI_element.visible = false
	is_player_inside = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button") or event.is_action_pressed("move_backward") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("space"):
		first_run = false
	if is_player_inside:
		if event.is_action_pressed("action_button"):
			visible = !visible
			player.player_do_sus = !player.player_do_sus
			player.can_move = !player.can_move
			
