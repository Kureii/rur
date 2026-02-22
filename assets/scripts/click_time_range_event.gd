@tool
extends Control

signal _open_door
signal _turn_on_blet

@export var player_sus_normal: float = 20.0
@export var player_sus_bad: float = 50.0

@export_range(0.0, 50.0, 0.1) var speed: float = 1.0
@export_range(0.0, 1.0, 0.01) var action_slider_position: float = 0.5:
	set(p):
		action_slider_position = clamp(p, 0.0, 1.0)
		_update_layout()

@export_group("Visual")
@export_color_no_alpha var bad_fill_color: Color = Color("a90000"):
	set(c):
		bad_fill_color = c
		_update_layout()
@export_color_no_alpha var neutral_fill_color: Color = Color("d66b00"):
	set(c):
		neutral_fill_color = c
		_update_layout()
@export_color_no_alpha var good_fill_color: Color = Color("00dd00"):
	set(c):
		good_fill_color = c
		_update_layout()
@export_color_no_alpha var action_slider_fill_color: Color = Color("4f9bff"):
	set(c):
		action_slider_fill_color = c
		_update_layout()
@export_range(0.0, 1.0, 0.01) var neutral_size_ratio: float = 0.5:
	set(r):
		neutral_size_ratio = r
		_update_layout()
@export_range(0.0, 1.0, 0.01) var neutral_position_ratio: float = 0.5:
	set(p):
		neutral_position_ratio = p
		_update_layout()
@export_range(0.0, 1.0, 0.01) var good_size_ratio: float = 0.5:
	set(r):
		good_size_ratio = r
		_update_layout()
@export_range(0.0, 1.0, 0.01) var good_position_ratio: float = 0.5:
	set(p):
		good_position_ratio = p
		_update_layout()
@export var action_slider_width: float = 5.0:
	set(w):
		action_slider_width = w
		_update_layout()
@export var action_slider_height: float = 50.0:
	set(h):
		action_slider_height = h
		_update_layout()
@export var slider_size: Vector2 = Vector2(800, 40):
	set(s):
		slider_size = s
		_update_layout()

@onready var player: RigidBody3D = %Player
@onready var UI_element: Control = %TakeKey
@export var sus_per_second: float = 5.0

var _slider_bg: ColorRect
var _neutral_rect: ColorRect
var _good_rect: ColorRect
var _action_rect: ColorRect
var _built: bool = false

var running: bool = true
var is_player_inside: bool = false
var done: bool = false

var reset_timer: Timer

func _ready() -> void:
	_build_ui()
	if not Engine.is_editor_hint():
		await get_tree().process_frame
	_update_layout()
	resized.connect(_update_layout)
	reset_timer = Timer.new()
	reset_timer.wait_time = 4
	reset_timer.one_shot = true
	reset_timer.timeout.connect(_on_reset_timeout)
	add_child(reset_timer)

func _start_reset_timer():
	reset_timer.wait_time = 4
	reset_timer.start()

func _on_reset_timeout():
	running = true
	done = false

func _build_ui() -> void:
	_slider_bg = get_node_or_null("SliderBG") as ColorRect
	if _slider_bg == null:
		_slider_bg = ColorRect.new()
		_slider_bg.name = "SliderBG"
		add_child(_slider_bg)
		if Engine.is_editor_hint():
			_slider_bg.owner = get_tree().edited_scene_root

	_neutral_rect = get_node_or_null("SliderBG/NeutralZone") as ColorRect
	if _neutral_rect == null:
		_neutral_rect = ColorRect.new()
		_neutral_rect.name = "NeutralZone"
		_slider_bg.add_child(_neutral_rect)
		if Engine.is_editor_hint():
			_neutral_rect.owner = get_tree().edited_scene_root

	_good_rect = get_node_or_null("SliderBG/NeutralZone/GoodZone") as ColorRect
	if _good_rect == null:
		_good_rect = ColorRect.new()
		_good_rect.name = "GoodZone"
		_neutral_rect.add_child(_good_rect)
		if Engine.is_editor_hint():
			_good_rect.owner = get_tree().edited_scene_root

	_action_rect = get_node_or_null("SliderBG/ActionSlider") as ColorRect
	if _action_rect == null:
		_action_rect = ColorRect.new()
		_action_rect.name = "ActionSlider"
		_slider_bg.add_child(_action_rect)
		if Engine.is_editor_hint():
			_action_rect.owner = get_tree().edited_scene_root

	_slider_bg.move_child(_action_rect, -1)
	_built = true

func _update_layout() -> void:
	if not _built:
		return

	var sw: float = slider_size.x
	var sh: float = slider_size.y

	# SliderBG vycentrovaný v rámci rodičovského Control uzlu
	_slider_bg.color = bad_fill_color
	_slider_bg.size = slider_size
	_slider_bg.position = (size - slider_size) * 0.5

	var neutral_w: float = sw * neutral_size_ratio
	var neutral_x: float = (sw - neutral_w) * neutral_position_ratio
	_neutral_rect.color = neutral_fill_color
	_neutral_rect.position = Vector2(neutral_x, 0)
	_neutral_rect.size = Vector2(neutral_w, sh)

	var good_w: float = neutral_w * good_size_ratio
	var good_x: float = (neutral_w - good_w) * good_position_ratio
	_good_rect.color = good_fill_color
	_good_rect.position = Vector2(good_x, 0)
	_good_rect.size = Vector2(good_w, sh)

	var slider_h: float = action_slider_height
	var slider_w: float = action_slider_width
	var slider_x: float = (sw - slider_w) * action_slider_position
	var slider_y: float = (sh - slider_h) * 0.5
	_action_rect.color = action_slider_fill_color
	_action_rect.position = Vector2(slider_x, slider_y)
	_action_rect.size = Vector2(slider_w, slider_h)

func _process(delta: float) -> void:
	if done:
		return

	if running:
		if Engine.is_editor_hint():
			_update_layout()
		else:
			var t: float = Time.get_ticks_msec() / 1000.0 * speed
			action_slider_position = (sin(t) + 1.0) * 0.5

	if not Engine.is_editor_hint():
		if player and player.player_do_sus:
			player.player_sus += sus_per_second * delta

func _change_visibility() -> void:
	visible = not visible
	player.player_do_sus = not player.player_do_sus
	player.can_move = not player.can_move

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if is_player_inside and event.is_action_pressed("action_button"):
		_change_visibility()
	if event.is_action_pressed("space"):
		running = false
		var zone: String = _get_zone_at(action_slider_position)
		print("Stopped on: ", zone)
		if zone == "good":
			_open_door.emit()
			_turn_on_blet.emit()
		if zone == "neutral":
			_open_door.emit()
			player.player_sus += player_sus_normal
		if zone == "bad":
			player.player_sus += player_sus_bad
			_start_reset_timer()

func _get_zone_at(pos: float) -> String:
	var sw: float = slider_size.x

	var n_left: float = (1.0 - neutral_size_ratio) * neutral_position_ratio
	var n_right: float = n_left + neutral_size_ratio

	var g_left: float = n_left + (neutral_size_ratio - neutral_size_ratio * good_size_ratio) * good_position_ratio
	var g_right: float = g_left + neutral_size_ratio * good_size_ratio

	var center: float = pos + (action_slider_width * 0.5) / sw

	if center >= g_left and center <= g_right:
		return "good"
	elif center >= n_left and center <= n_right:
		return "neutral"
	else:
		return "bad"

func _on_range_minigame_body_entered(body: Node3D) -> void:
	is_player_inside = true
	UI_element.visible = true

func _on_range_minigame_body_exited(body: Node3D) -> void:
	is_player_inside = false
	UI_element.visible = false

func _on_close_button_pressed() -> void:
	_change_visibility()
