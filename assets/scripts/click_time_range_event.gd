@tool
extends Control

@export_range(0.0,50.0,0.1) var speed: float = 1.0
@export_range(0.0, 1.0, 0.01) var action_slider_position: float = 0.5:
	set(p):
		action_slider_position = p
		_set_action_slider_position()
@export_group("Visual")
@export_color_no_alpha var bad_fill_color: Color = Color("a90000"):
	set(c):
		bad_fill_color = c
		_set_bad_fill_color()
@export_color_no_alpha var neutral_fill_color: Color = Color("d66b00"):
	set(c):
		neutral_fill_color = c
		_set_neutral_fill_color()
@export_color_no_alpha var good_fill_color: Color = Color("00dd00"):
	set(c):
		good_fill_color = c
		_set_good_fill_color()
@export_color_no_alpha var action_slider_fill_color: Color = Color("4f9bff"):
	set(c):
		action_slider_fill_color = c
		_set_action_slider_fill_color()
@export_range(0.0, 1.0, 0.01) var neutral_size_ratio: float = 0.5:
	set(r):
		neutral_size_ratio = r
		_set_neutral_width()
		_set_neutral_position()
@export_range(0.0, 1.0, 0.01) var neutral_position_ratio: float = 0.5:
	set(p):
		neutral_position_ratio = p
		_set_neutral_width()
		_set_neutral_position()
@export_range(0.0, 1.0, 0.01) var good_size_ratio: float = 0.5:
	set(r):
		good_size_ratio = r
		_set_good_width()
		_set_good_position()
@export_range(0.0, 1.0, 0.01) var good_position_ratio: float = 0.5:
	set(p):
		good_position_ratio = p
		_set_good_width()
		_set_good_position()
@export var action_slider_size: Vector2 = Vector2(5,50):
	set(s):
		action_slider_size = s
		_set_action_slider_size()
@export var slider_size: Vector2 = Vector2(800,40):
	set(s):
		slider_size = s
		_load_all()

var slider

var bad_fill_rect
var neutral_fill_rect
var good_fill_rect

var neutral_fill_left_spacer
var good_fill_left_spacer

var action_slider

var action_slider_left_spacer
var action_slider_right_spacer

var running: bool = true
var first_run: bool = true

func _get_color_rect():
	slider = get_node_or_null("SliderContainer/Slider")
	
	bad_fill_rect = get_node_or_null("SliderContainer/Slider/MarginInsideSlider/BadFill")
	neutral_fill_rect = get_node_or_null("SliderContainer/Slider/MarginInsideSlider/BadFill/HBoxContainer/NeutralFill")
	good_fill_rect = get_node_or_null("SliderContainer/Slider/MarginInsideSlider/BadFill/HBoxContainer/NeutralFill/HBoxContainer/GoodFill")
	
	neutral_fill_left_spacer = get_node_or_null("SliderContainer/Slider/MarginInsideSlider/BadFill/HBoxContainer/NeutralFillLeftSpacer")
	good_fill_left_spacer = get_node_or_null("SliderContainer/Slider/MarginInsideSlider/BadFill/HBoxContainer/NeutralFill/HBoxContainer/GoodFillLeftSpacer")
	
	action_slider = get_node_or_null("SliderContainer/Slider/MarginOutsiteSlider/MarginOutsideContainer/ActionSlider")
	
func _get_transparent_rect():
	action_slider_left_spacer = get_node_or_null("SliderContainer/Slider/MarginOutsiteSlider/MarginOutsideContainer/ActionSliderLeftSpacer")
	action_slider_right_spacer = get_node_or_null("SliderContainer/Slider/MarginOutsiteSlider/MarginOutsideContainer/ActionSliderRightSpacer")
	
func _set_bad_fill_color():
	_get_color_rect()
	if !bad_fill_rect or !neutral_fill_left_spacer: return
	bad_fill_rect.color = bad_fill_color
	neutral_fill_left_spacer.color = bad_fill_color
	
func _set_neutral_fill_color():
	_get_color_rect()
	if !neutral_fill_rect or !good_fill_left_spacer: return
	neutral_fill_rect.color = neutral_fill_color
	good_fill_left_spacer.color = neutral_fill_color
	
func _set_good_fill_color():
	_get_color_rect()
	if !good_fill_rect: return
	good_fill_rect.color = good_fill_color

func _set_action_slider_fill_color():
	_get_color_rect()
	if !action_slider: return
	action_slider.color = action_slider_fill_color
		
func _set_slider_size():
	_get_color_rect()
	if !slider: return
	slider.custom_minimum_size = slider_size
	slider.size = slider_size

func _set_neutral_width():
	_get_color_rect()
	if !bad_fill_rect or !neutral_fill_rect: return
	neutral_fill_rect.custom_minimum_size.x = bad_fill_rect.size.x * neutral_size_ratio
	neutral_fill_rect.size.x =bad_fill_rect.size.x * neutral_size_ratio
	
func _set_neutral_position():
	_get_color_rect()
	if !bad_fill_rect or !neutral_fill_left_spacer or !neutral_fill_rect: return
	neutral_fill_left_spacer.custom_minimum_size.x = (bad_fill_rect.size.x - neutral_fill_rect.size.x) * neutral_position_ratio
	neutral_fill_left_spacer.size.x = (bad_fill_rect.size.x - neutral_fill_rect.size.x) * neutral_position_ratio
	
func _set_good_width():
	_get_color_rect()
	if !neutral_fill_rect or !good_fill_rect: return
	good_fill_rect.custom_minimum_size.x = neutral_fill_rect.size.x * good_size_ratio
	good_fill_rect.size.x = neutral_fill_rect.size.x * good_size_ratio
	
func _set_good_position():
	_get_color_rect()
	if !neutral_fill_rect or !good_fill_left_spacer or !good_fill_rect: return
	good_fill_left_spacer.custom_minimum_size.x = (neutral_fill_rect.size.x - good_fill_rect.size.x) * good_position_ratio
	good_fill_left_spacer.size.x = (neutral_fill_rect.size.x - good_fill_rect.size.x) * good_position_ratio
	
func _set_action_slider_size():
	_get_color_rect()
	_get_transparent_rect()
	if !action_slider or !action_slider_left_spacer or !action_slider_right_spacer: return
	action_slider.custom_minimum_size = action_slider_size
	action_slider.size = action_slider_size
	action_slider_left_spacer.size.y = action_slider_size.y
	action_slider_right_spacer.size.y = action_slider_size.y
	
func _set_action_slider_position():
	_get_transparent_rect()
	_get_color_rect()
	if !action_slider or !bad_fill_rect or !action_slider_left_spacer or !action_slider_right_spacer: return
	action_slider_left_spacer.size.x = (bad_fill_rect.size.x - action_slider.size.x) * action_slider_position
	action_slider_left_spacer.custom_minimum_size.x = (bad_fill_rect.size.x - action_slider.size.x) * action_slider_position
	action_slider_right_spacer.size.x = (bad_fill_rect.size.x - action_slider.size.x) * (1.0 - action_slider_position)
	action_slider_right_spacer.custom_minimum_size.x = (bad_fill_rect.size.x - action_slider.size.x) * (1.0 - action_slider_position)
	
func _load_all():
	_set_bad_fill_color()
	_set_neutral_fill_color()
	_set_good_fill_color()
	_set_action_slider_fill_color()
	_set_slider_size()
	_set_neutral_width()
	_set_neutral_position()
	_set_good_width()
	_set_good_position()
	_set_action_slider_size()
	_set_action_slider_position()
	
func _ready() -> void:
	_load_all()
	
func _process(delta: float) -> void:
	if running:
		if Engine.is_editor_hint():
			_load_all()
		if first_run:
			first_run = false
			_load_all()
		var t = Time.get_ticks_msec() / 1000.0 * speed
		action_slider_position = (sin(t) + 1) * 0.5
	
func _input(event: InputEvent) -> void:
	if event.is_action("space"):
		running = false
