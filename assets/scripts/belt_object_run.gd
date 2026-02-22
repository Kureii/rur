extends PathFollow3D

@export var speed : float = 30
@export var destroy: bool = false

func _process(delta: float) -> void:
	if !destroy:
		progress += (delta * speed)- int(delta * speed)
	else:
		var old_progress = progress
		progress += (delta * speed)- int(delta * speed)
		if old_progress > progress:
			queue_free()
