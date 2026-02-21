@tool
extends MeshInstance3D

@export var sus_per_second:float = 5.0
@export_range(0.01, 20.0,0.01) var speed = 0.25
@export var radius: float = 3.0: 
	set(v):
		radius = v
		_set_bottom_radius()

@export var volume_bottom_add: float = 3.0:
	set(v):
		volume_bottom_add = v
		_set_bottom_radius()
	
@export_range(0.01,1.0,0.01) var thick: float = 0.2:
	set(v):
		thick = v
		_set_line_thick(v)

@export var length: float = 3.0:
	set(v):
		length = v
		_set_line_offset(v)
		_set_length(v)
		
@export var volume_top: float = 1.0:
	set(v):
		volume_top = v
		_get_nodes()
		if not vol: return
		vol.mesh.top_radius = v

@export var raycast: Array[Node]
@export var player: CharacterBody3D
var line: Node3D
var line_origins: Array[Node]
var vol: MeshInstance3D

func _get_nodes():
	vol = get_node_or_null("Volume")
	var raycast_array_node = get_node_or_null("RayCastArray")
	if raycast_array_node:
		raycast = raycast_array_node.get_children()
	line = get_node_or_null("Lines")
	if line:
		line_origins = line.get_children()

func _set_bottom_radius():
	_get_nodes()
	if not vol: return
	vol.mesh.bottom_radius = radius + volume_bottom_add

func _set_line_offset(length: float):
	_get_nodes()
	if line_origins.is_empty(): return
	for origin in line_origins:
		origin.get_child(0).position.y = -length / 2
	if not vol: return
	vol.position.y = -length / 2

func _set_line_thick(thick: float):
	_get_nodes()
	if line_origins.is_empty(): return
	for origin in line_origins:
		origin.get_child(0).mesh.top_radius = thick
		origin.get_child(0).mesh.bottom_radius = thick

func _set_length(length: float):
	_get_nodes()
	if raycast.is_empty() or line_origins.is_empty() or not vol: return
	for origin in line_origins:
		origin.get_child(0).mesh.height = length
	for rc in raycast:
		rc.target_position = Vector3(rc.target_position.x, -length, rc.target_position.z)
	vol.mesh.height = length

func _ready() -> void:
	_get_nodes()
	_set_line_offset(length)
	_set_line_thick(thick)
	_set_length(length)
	_set_bottom_radius()
	
func _process(delta: float) -> void:
	var t = Time.get_ticks_msec() / 1000.0 * speed
	var number_of_lines = line_origins.size()
	for i in range(number_of_lines) :
		line_origins[i].rotation.z = sin(t + (i+1) * (PI/(number_of_lines/2))) * radius
		line_origins[i].rotation.x = cos(t * (i+1) * (PI/(number_of_lines/2))) * radius * PI/20
	var hit_player: bool = false
	var number_of_raycast = raycast.size()
	for i in range(number_of_raycast):
		var sin_t = sin(t * 10 * (PI / number_of_raycast) * (i+1) ) * radius
		
		raycast[i].target_position.x = sin_t * PI * 2.0
		raycast[i].target_position.y = -length + abs(sin_t)
		
		if raycast[i].is_colliding() and !hit_player:
			var hit = raycast[i].get_collider()
			if hit == player and player.player_do_sus:
				player.player_sus += delta * sus_per_second
				hit_player = true
	

	
	
