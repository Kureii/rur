extends PathFollow3D

@export var speed : float = 30

func _process(delta: float) -> void:
	progress += (delta * speed)- int(delta * speed)
