extends Path3D

@export var timer = 0
@export var spawn_time: float = 5.5

@export var speed: float = 2.0
@export var max_spowned: int = 24

var follower = preload("res://assets/core_scenes/belt_object.tscn")
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
