extends Path3D

@export var timer = 0
@export var spawn_time: float = 5.5

@export var speed: float = 2.0
@export var max_spowned: int = 24

@export var follower = preload("res://assets/core_scenes/belt_object-shit.tscn")
var spawned: int = 0 


func _process(delta: float) -> void:
	if spawned < max_spowned:
		timer += delta
		
		if timer > spawn_time:
			spawned +=1
			var new_folower = follower.instantiate()
			new_folower.speed = speed
			add_child(new_folower)
			timer = 0


func _on_emplace_takeble_destroy() -> void:
	var children = get_children()
	for child in children:
		if child is PathFollow3D:
			child.speed = 0
